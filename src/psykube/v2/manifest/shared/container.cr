class Psykube::V2::Manifest::Shared::Container
  Macros.mapping({
    image:            {type: String, optional: true},
    tag:              {type: String, optional: true},
    build_context:    {type: String, default: "."},
    build_args:       {type: StringMap, default: StringMap.new},
    healthcheck:      {type: Bool | Manifest::Healthcheck, optional: true, default: false},
    readycheck:       {type: Bool | Manifest::Readycheck, optional: true, default: false},
    ports:            {type: PortMap, default: PortMap.new},
    volumes:          {type: Hash(String, String), default: {} of String => String},
    resources:        {type: Manifest::Resources, optional: true},
    env:              {type: Hash(String, Manifest::Env | String), optional: true},
    command:          {type: Array(String) | String, optional: true},
    args:             {type: Array(String), optional: true},
    security_context: {type: SecurityContext, optional: true},
  })

  def env
    env = @env || {} of String => Manifest::Env | String
    return env unless ports?
    env["PORT"] = lookup_port("default").to_s
    ports.each_with_object(env) do |(name, port), env|
      env["#{name.underscore.upcase.gsub(/(-\.)/, "_")}_PORT"] = port.to_s
    end
  end

  def ports?
    !ports.empty?
  end

  def lookup_port(port : Int32)
    port
  end

  def lookup_port(port_name : String)
    if port_name.to_i?
      port_name.to_i
    elsif port_name == "default" && !ports.key?("default")
      ports.values.first
    else
      ports[port_name]? || raise "Invalid port #{port_name}"
    end
  end
end

require "./container/*"