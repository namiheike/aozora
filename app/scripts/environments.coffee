Aozora = window.Aozora

Aozora.env ||= {}

Aozora.env.platform =
  isPhonegap: false

document.addEventListener 'deviceready', ( ->
  console.log 'device ready'

  Aozora.env.platform.isPhonegap = true
), false
