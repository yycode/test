import Bullet from './Bullet'

export default class Tank {
  position: { x: number, y: number }
  width: number
  height: number
  color: string
  private speed: number
  private readonly worldWidth: number

  constructor(position: { x: number, y: number }, width: number, height: number, color: string, speed: number, worldWidth: number) {
    this.position = position
    this.width = width
    this.height = height
    this.color = color
    this.speed = speed
    this.worldWidth = worldWidth
  }

  moveLeft() {
    this.position.x = Math.max(0, this.position.x - this.speed)
  }

  moveRight() {
    this.position.x = Math.min(this.worldWidth - this.width, this.position.x + this.speed)
  }

  fire() {
    const bulletX = this.position.x + this.width / 2 - 2
    const bulletY = this.position.y - 8
    return new Bullet({ x: bulletX, y: bulletY }, 4, 10, '#FFD54F', -6)
  }

  draw(ctx: CanvasRenderingContext2D) {
    // Body
    ctx.fillStyle = this.color
    ctx.fillRect(this.position.x, this.position.y, this.width, this.height)

    // Turret
    ctx.fillStyle = '#81C784'
    const turretWidth = this.width * 0.4
    const turretHeight = this.height * 0.4
    ctx.fillRect(this.position.x + this.width / 2 - turretWidth / 2, this.position.y - turretHeight, turretWidth, turretHeight)

    // Barrel
    ctx.fillStyle = '#A5D6A7'
    ctx.fillRect(this.position.x + this.width / 2 - 2, this.position.y - turretHeight - 10, 4, 10)
  }
}