export default class Bullet {
  position: { x: number, y: number }
  width: number
  height: number
  color: string
  velocityY: number
  active: boolean = true

  constructor(position: { x: number, y: number }, width: number, height: number, color: string, velocityY: number) {
    this.position = position
    this.width = width
    this.height = height
    this.color = color
    this.velocityY = velocityY
  }

  update() {
    this.position.y += this.velocityY
    if (this.position.y + this.height < 0) {
      this.active = false
    }
  }

  getBounds() {
    return { x: this.position.x, y: this.position.y, width: this.width, height: this.height }
  }

  draw(ctx: CanvasRenderingContext2D) {
    ctx.fillStyle = this.color
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height)
  }
}