class Psykube::V2::Manifest::Volume::Claim
  Macros.mapping({
    size:          {type: String},
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    annotations:   {type: StringMap, optional: true},
    storage_class: {type: String, optional: true},
    read_only:     {type: Bool, optional: true},
  })
end
