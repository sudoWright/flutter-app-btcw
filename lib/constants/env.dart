enum ApiEnvType {
  prod,
  atlas,
}

class ApiEnv {
  final ApiEnvType type;
  final String? custom; // Only used for the atlas type

  const ApiEnv.prod()
      : type = ApiEnvType.prod,
        custom = null;
  ApiEnv.atlas(this.custom) : type = ApiEnvType.atlas;

  @override
  String toString() {
    switch (type) {
      case ApiEnvType.prod:
        return "prod";
      case ApiEnvType.atlas:
        return "atlas${custom != null ? ':$custom' : ''}";
    }
  }
}

final jenner = ApiEnv.atlas("jenner");
