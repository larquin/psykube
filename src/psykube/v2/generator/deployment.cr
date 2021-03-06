class Psykube::V2::Generator::Deployment < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Deployment

  protected def result
    Pyrite::Api::Extensions::V1beta1::Deployment.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Extensions::V1beta1::DeploymentSpec.new(
        selector: generate_selector,
        replicas: manifest.replicas,
        revision_history_limit: manifest.rollout.try(&.history_limit),
        progress_deadline_seconds: manifest.rollout.try(&.progress_timeout),
        template: generate_pod_template,
        strategy: generate_strategy,
      )
    )
  end

  private def generate_strategy
    return Pyrite::Api::Extensions::V1beta1::DeploymentStrategy.new(type: "Recreate") if manifest.recreate
    Pyrite::Api::Extensions::V1beta1::DeploymentStrategy.new(
      type: "RollingUpdate",
      rolling_update: Pyrite::Api::Extensions::V1beta1::RollingUpdateDeployment.new(
        max_unavailable: manifest.rollout.try(&.max_unavailable),
        max_surge: manifest.rollout.try(&.max_surge),
      )
    )
  end
end
