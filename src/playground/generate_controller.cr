struct Psykube::Playground::GenerateController
  include Orion::ControllerHelper

  def generate
    if (body = context.request.body)
      gen = Actor.new(body).generate
      gen.to_json(context.response)
    end
  rescue e : Psykube::ParseException | Crustache::ParseError | V1::Generator::ValidationError | ArgumentError
    context.response.status_code = 422
    context.response << e.message
  end
end
