'use strict'
let component = require('omniscient')
let h = require('react-hyperscript')
let logger = require('js-logger-aknudsen').get('project.loading')

if (__IS_BROWSER__) {
  require('../loading.styl')
}

module.exports =  component('Loading', (cursor) => {
  let status = cursor.get('isLoading')
  logger.debug(`Rendering, status: '${status}'`)
  return h('div', [
    h('.spinner', [
      h('.rect1'),
      h('.rect2'),
      h('.rect3'),
      h('.rect4'),
      h('.rect5'),
    ]),
    h('p#loading-status', status),
  ])
})
