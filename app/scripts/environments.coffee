Aozora = window.Aozora

Aozora.env ||= {}

Aozora.env.debugging = true

Aozora.env.platform =
  isPhonegap: false
  device: undefined

document.addEventListener 'deviceready', ( ->
  Aozora.env.platform.isPhonegap = true
  Aozora.env.device = window.device
), false
