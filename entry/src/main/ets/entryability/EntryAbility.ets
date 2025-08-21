import UIAbility from '@ohos.app.ability.UIAbility'
import window from '@ohos.window'

export default class EntryAbility extends UIAbility {
  onCreate() {}

  onDestroy() {}

  onForeground() {}

  onBackground() {}

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err) {
        console.error(`Failed to load content. Code: ${err.code}, message: ${err.message}`)
        return
      }
    })
  }

  onWindowStageDestroy() {}
}