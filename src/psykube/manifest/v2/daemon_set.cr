require "yaml"
require "../../name_cleaner"

class Psykube::Manifest::V2::DaemonSet
  V2.declare_manifest("DaemonSet", {
    ready_timeout: Int32?,
    replicas:      Int32?,
    rollout:       {type: Rollout, nilable: true, getter: false},
  })

  def rollout
    case @rollout
    when .nil?
      Rollout.new
    when true
      @rollout
    end
  end
end

require "./daemon_set/*"