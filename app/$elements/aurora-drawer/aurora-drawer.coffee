Polymer
  is: 'aurora-drawer'
  behaviors: [Aurora.behaviors.base]
  properties:
    creditInfo:
      type: String

  # attached: () ->
    # init vars
    # cannot put in ready/attached since config is not loaded at that time
    # TODO HAVE TO separate config/resources loading process out of polymer
    # @creditInfo = @app.config.meta.author.name
