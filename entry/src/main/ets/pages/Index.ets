@Entry
@Component
struct Index {
  private readonly CANVAS_WIDTH: number = 360
  private readonly CANVAS_HEIGHT: number = 600

  private canvas: CanvasRenderingContext2D = new CanvasRenderingContext2D()
  @State private game: Game = new Game()

  aboutToAppear() {
    // no-op
  }

  aboutToDisappear() {
    this.game.stop()
  }

  build() {
    Column() {
      // Game canvas
      Canvas(this.canvas)
        .size({ width: this.CANVAS_WIDTH, height: this.CANVAS_HEIGHT })
        .backgroundColor(Color.Black)
        .onReady(() => {
          this.game.start(this.canvas, this.CANVAS_WIDTH, this.CANVAS_HEIGHT)
        })
        .border({ width: 1, color: Color.Grey })

      // Controls
      Row() {
        // Move Left
        Button('◀')
          .fontSize(20)
          .width('30%')
          .height(48)
          .gesture(
            LongPressGesture({ repeat: true, duration: 30 })
              .onAction(() => {
                this.game.queueMoveLeft()
              })
          )

        // Fire
        Button('FIRE')
          .fontSize(20)
          .width('40%')
          .height(48)
          .onClick(() => this.game.fire())

        // Move Right
        Button('▶')
          .fontSize(20)
          .width('30%')
          .height(48)
          .gesture(
            LongPressGesture({ repeat: true, duration: 30 })
              .onAction(() => {
                this.game.queueMoveRight()
              })
          )
      }
      .width(this.CANVAS_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 12 })

      // HUD
      Row() {
        Text(`Score: ${this.game.score}`)
          .fontColor(Color.White)
          .fontSize(16)
        Blank().layoutWeight(1)
        Text(`Lives: ${this.game.lives}`)
          .fontColor(Color.White)
          .fontSize(16)
      }
      .width(this.CANVAS_WIDTH)
      .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Black)
  }
}

import Game from '../game/Game'