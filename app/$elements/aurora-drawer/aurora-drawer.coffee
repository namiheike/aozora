Polymer
  is: 'aurora-drawer'
  behaviors: [Aurora.behaviors.base]
  properties:
    creditInfo:
      type: String

  attached: () ->
    # init vars
    # cannot put in ready since config is not loaded at that time
    # TODO maybe separate loader out of polymer
    @creditInfo = @app.config.meta.author.name
