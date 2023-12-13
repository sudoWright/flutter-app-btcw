/*
 * Copyright (c) 2023 Proton AG
 * This file is part of Proton AG and Proton Pass.
 *
 * Proton Pass is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Proton Pass is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Proton Pass.  If not, see <https://www.gnu.org/licenses/>.
 */

/*
 * Copyright (c) 2022 Proton Technologies AG
 * This file is part of Proton Technologies AG and Proton Mail.
 *
 * Proton Mail is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Proton Mail is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Proton Mail. If not, see <https://www.gnu.org/licenses/>.
 */

package com.example.wallet.ui.launcher

import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultCaller
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import me.proton.core.account.domain.entity.Account
import me.proton.core.account.domain.entity.AccountType
import me.proton.core.account.domain.entity.isDisabled
import me.proton.core.account.domain.entity.isReady
import me.proton.core.account.domain.entity.isStepNeeded
import me.proton.core.accountmanager.domain.AccountManager
import me.proton.core.accountmanager.presentation.observe
import me.proton.core.accountmanager.presentation.onAccountCreateAddressFailed
import me.proton.core.accountmanager.presentation.onAccountCreateAddressNeeded
import me.proton.core.accountmanager.presentation.onAccountTwoPassModeFailed
import me.proton.core.accountmanager.presentation.onAccountTwoPassModeNeeded
import me.proton.core.accountmanager.presentation.onSessionForceLogout
import me.proton.core.accountmanager.presentation.onSessionSecondFactorNeeded
import me.proton.core.auth.presentation.AuthOrchestrator
import me.proton.core.auth.presentation.onAddAccountResult
import me.proton.core.domain.entity.Product
import me.proton.core.domain.entity.UserId
import me.proton.core.plan.presentation.PlansOrchestrator
import me.proton.core.plan.presentation.onUpgradeResult
import me.proton.core.report.presentation.ReportOrchestrator
import me.proton.core.user.domain.UserManager
import me.proton.core.usersettings.presentation.UserSettingsOrchestrator
//import com.example.wallet.common.api.flatMap
//import com.example.wallet.commonrust.api.CommonLibraryVersionChecker
//import com.example.wallet.data.api.repositories.ItemSyncStatus
//import com.example.wallet.data.api.repositories.ItemSyncStatusRepository
//import com.example.wallet.data.api.repositories.SyncMode
//import com.example.wallet.data.api.usecases.ClearUserData
//import com.example.wallet.data.api.usecases.RefreshPlan
//import com.example.wallet.data.api.usecases.UserPlanWorkerLauncher
//import com.example.wallet.inappupdates.api.InAppUpdatesManager
//import com.example.wallet.preferences.InternalSettingsRepository
//import com.example.wallet.preferences.UserPreferencesRepository
import com.example.wallet.log.api.WalletLogger
import javax.inject.Inject

@HiltViewModel
@Suppress("LongParameterList")
class LauncherViewModel @Inject constructor(
    private val product: Product,
    private val requiredAccountType: AccountType,
    private val accountManager: AccountManager,
    private val userManager: UserManager,
    private val authOrchestrator: AuthOrchestrator,
    private val plansOrchestrator: PlansOrchestrator,
    private val reportOrchestrator: ReportOrchestrator,
    private val userSettingsOrchestrator: UserSettingsOrchestrator,
//    private val preferenceRepository: UserPreferencesRepository,
//    private val internalSettingsRepository: InternalSettingsRepository,
//    private val userPlanWorkerLauncher: UserPlanWorkerLauncher,
//    private val itemSyncStatusRepository: ItemSyncStatusRepository,
//    private val clearUserData: ClearUserData,
//    private val refreshPlan: RefreshPlan,
//    private val inAppUpdatesManager: InAppUpdatesManager,
//    commonLibraryVersionChecker: CommonLibraryVersionChecker
) : ViewModel() {

    init {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
//                val version = runCatching { commonLibraryVersionChecker.getVersion() }
//                    .getOrElse { "Unknown" }
//                WalletLogger.i(TAG, "Common library version: $version")
            }
        }

        viewModelScope.launch {
            //refreshPlan()
        }
    }

    val state: StateFlow<State> = accountManager.getAccounts()
        .map { accounts ->
            when {
                accounts.isEmpty() || accounts.all { it.isDisabled() } -> {
                    clearPassUserData(accounts)
                    State.AccountNeeded
                }

                accounts.any { it.isReady() } -> {
                    accounts.firstOrNull { it.isReady() }?.let {
                        WalletLogger.i(TAG, "SessionID=${it.sessionId?.id}")
                    }
                    State.PrimaryExist
                }
                accounts.any { it.isStepNeeded() } -> State.StepNeeded
                else -> State.Processing
            }
        }
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.Lazily,
            initialValue = State.Processing
        )

    fun register(context: ComponentActivity) {
        authOrchestrator.register(context as ActivityResultCaller)
        plansOrchestrator.register(context)
        reportOrchestrator.register(context)
        userSettingsOrchestrator.register(context)

        authOrchestrator.onAddAccountResult { result ->
            viewModelScope.launch {
                if (result == null && getPrimaryUserIdOrNull() == null) {
                    context.finish()
                    return@launch
                }

                if (result != null) {
                    WalletLogger.i(TAG, "Sending User Access")
//                    itemSyncStatusRepository.setMode(SyncMode.ShownToUser)
//                    itemSyncStatusRepository.emit(ItemSyncStatus.Started)
                }
            }
        }

        accountManager.observe(context.lifecycle, Lifecycle.State.CREATED)
            .onSessionForceLogout { userManager.lock(it.userId) }
            .onAccountTwoPassModeFailed { accountManager.disableAccount(it.userId) }
            .onAccountCreateAddressFailed { accountManager.disableAccount(it.userId) }
            .onSessionSecondFactorNeeded { authOrchestrator.startSecondFactorWorkflow(it) }
            .onAccountTwoPassModeNeeded { authOrchestrator.startTwoPassModeWorkflow(it) }
            .onAccountCreateAddressNeeded { authOrchestrator.startChooseAddressWorkflow(it) }
    }

    fun onUserStateChanced(state: State) = viewModelScope.launch {
        when (state) {
//            State.AccountNeeded -> userPlanWorkerLauncher.cancel()
//            State.PrimaryExist -> userPlanWorkerLauncher.start()
            State.Processing,
            State.StepNeeded -> {
                // no-op
            }

            else -> {}
        }
    }

    fun addAccount() = viewModelScope.launch {
        authOrchestrator.startAddAccountWorkflow(
            requiredAccountType = requiredAccountType,
            creatableAccountType = requiredAccountType,
            product = product
        )
    }

    fun signIn(callback: () -> (Unit), userId: UserId? = null) = viewModelScope.launch {
        val account = userId?.let { getAccountOrNull(it) }
        authOrchestrator.startLoginWorkflow(requiredAccountType, username = account?.username)
        authOrchestrator.setOnLoginResult {
            if (it != null) {
                it.userId
                it.nextStep
            }
            callback()
        }
    }

    fun signUp(callback: () -> (Unit)) = viewModelScope.launch {
        authOrchestrator.startSignupWorkflow(
            creatableAccountType = requiredAccountType
        )
        authOrchestrator.setOnSignUpResult {
            if (it != null) {
                it.userId
                it.username
            }
            callback()
        }
    }

    fun signOut(userId: UserId? = null) = viewModelScope.launch {
        accountManager.disableAccount(requireNotNull(userId ?: getPrimaryUserIdOrNull()))
        clearPreferencesIfNeeded()
    }

//    fun switch(userId: UserId) = viewModelScope.launch {
//        val account = getAccountOrNull(userId) ?: return@launch
//        when {
//            account.isDisabled() -> signIn(userId)
//            account.isReady() -> accountManager.setAsPrimary(userId)
//        }
//    }

    fun remove(userId: UserId? = null) = viewModelScope.launch {
        accountManager.removeAccount(requireNotNull(userId ?: getPrimaryUserIdOrNull()))
        clearPreferencesIfNeeded()
    }

    private suspend fun clearPreferencesIfNeeded() {
        val accounts = accountManager.getAccounts().first()
        if (accounts.isEmpty()) {
//            preferenceRepository.clearPreferences()
//                .flatMap { internalSettingsRepository.clearSettings() }
//                .onSuccess { WalletLogger.d(TAG, "Clearing preferences success") }
//                .onFailure {
//                    WalletLogger.w(TAG, it, "Error clearing preferences")
//                }
        }
    }

    fun subscription() = viewModelScope.launch {
        getPrimaryUserIdOrNull()?.let {
            plansOrchestrator.showCurrentPlanWorkflow(it)
        }
    }

    fun upgrade() = viewModelScope.launch {
        getPrimaryUserIdOrNull()?.let {
            plansOrchestrator
                .onUpgradeResult { result ->
                    if (result != null) {
                        viewModelScope.launch {
                            runCatching {
//                                refreshPlan()
                            }
                                .onFailure { e ->
                                    WalletLogger.w(TAG, e, "Failed refreshing plan")
                                }
                        }
                    }
                }
                .startUpgradeWorkflow(it)
        }
    }

    fun report() = viewModelScope.launch {
        reportOrchestrator.startBugReport()
    }

    fun passwordManagement() = viewModelScope.launch {
        getPrimaryUserIdOrNull()?.let {
            userSettingsOrchestrator.startPasswordManagementWorkflow(it)
        }
    }

    private suspend fun clearPassUserData(accounts: List<Account>) {
        val disabledAccounts = accounts.filter { it.isDisabled() }
        disabledAccounts.forEach { account ->
            WalletLogger.i(TAG, "Clearing user data")
            runCatching {
//                clearUserData(account.userId)
            }
                .onSuccess { WalletLogger.i(TAG, "Cleared user data") }
                .onFailure { WalletLogger.i(TAG, it, "Error clearing user data") }
        }

        // If there are no accounts left, disable autofill and clear preferences
        val allDisabled = accounts.all { it.isDisabled() }
        if (accounts.isEmpty() || allDisabled) {
//            preferenceRepository.clearPreferences()
//                .flatMap { internalSettingsRepository.clearSettings() }
//                .onSuccess { WalletLogger.d(TAG, "Clearing preferences success") }
//                .onFailure {
//                    WalletLogger.w(TAG, it, "Error clearing preferences")
//                }
        }
    }

    private suspend fun getAccountOrNull(it: UserId) = accountManager.getAccount(it).firstOrNull()
    private suspend fun getPrimaryUserIdOrNull() = accountManager.getPrimaryUserId().firstOrNull()

//    fun checkForUpdates(updateResultLauncher: ActivityResultLauncher<IntentSenderRequest>) {
//        inAppUpdatesManager.checkForUpdates(updateResultLauncher)
//    }
//
//    fun cancelUpdateListener() {
//        inAppUpdatesManager.tearDown()
//    }
//
//    fun declineUpdate() {
//        inAppUpdatesManager.declineUpdate()
//    }

    enum class State { Processing, AccountNeeded, PrimaryExist, StepNeeded }

    companion object {
        private const val TAG = "LauncherViewModel"
    }
}
