export default class Enemy {
  position: { x: number, y: number }
  width: number
  height: number
  color: string
  speed: number
  active: boolean = true

  constructor(position: { x: number, y: number }, width: number, height: number, color: string, speed: number) {
    this.position = position
    this.width = width
    this.height = height
    this.color = color
    this.speed = speed
  }

  update() {
    this.position.y += this.speed
  }

  getBounds() {
    return { x: this.position.x, y: this.position.y, width: this.width, height: this.height }
  }

  draw(ctx: CanvasRenderingContext2D) {
    ctx.fillStyle = this.color

    // Chassis
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height)

    // Turret
    ctx.fillStyle = '#FF8A80'
    const turretWidth = this.width * 0.4
    const turretHeight = this.height * 0.35
    ctx.fillRect(this.position.x + this.width / 2 - turretWidth / 2, this.position.y - turretHeight / 2, turretWidth, turretHeight)

    // Barrel
    ctx.fillStyle = '#FFCDD2'
    ctx.fillRect(this.position.x + this.width / 2 - 2, this.position.y - 6, 4, 6)
  }
}