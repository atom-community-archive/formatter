# https://github.com/atom-community/autocomplete-plus/blob/master/lib/provider-metadata.coffee

{Disposable, CompositeDisposable} = require 'atom'
{specificity} = require 'clear-cut'
{Selector} = require 'selector-kit'
{selectorForScopeChain, selectorsMatchScopeChain} = require './scope-helpers'

module.exports =
class ProviderMetadata extends CompositeDisposable
  constructor: (@provider) ->
    @selectors = Selector.create(@provider.selector)
    @disableForSelectors = Selector.create(@provider.disableForSelector) if @provider.disableForSelector?
    return this

  dispose: () ->
    return

  matchesScopeChain: (scopeChain) ->
    if @disableForSelectors?
      return false if selectorsMatchScopeChain(@disableForSelectors, scopeChain)

    if selectorsMatchScopeChain(@selectors, scopeChain)
      true
    else
      false

  getSpecificity: (scopeChain) ->
    if selector = selectorForScopeChain(@selectors, scopeChain)
      selector.getSpecificity()
    else
      0
