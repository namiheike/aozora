Aurora = window.Aurora

Aurora.env ||= {}

Aurora.env.debugging = true

Aurora.env.platform =
  isPhonegap: false
  device: undefined

document.addEventListener 'deviceready', ( ->
  Aurora.env.platform.isPhonegap = true
  Aurora.env.device = window.device
), false
