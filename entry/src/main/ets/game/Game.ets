import Tank from './Tank'
import Bullet from './Bullet'
import Enemy from './Enemy'

export default class Game {
  private ctx?: CanvasRenderingContext2D
  private canvasWidth: number = 0
  private canvasHeight: number = 0
  private frameTimer: number | undefined
  private readonly targetFps: number = 60

  private player: Tank | undefined
  private enemies: Enemy[] = []
  private bullets: Bullet[] = []
  private lastEnemySpawnMs: number = 0
  private readonly enemySpawnIntervalMs: number = 1200

  score: number = 0
  lives: number = 3

  start(ctx: CanvasRenderingContext2D, width: number, height: number) {
    this.ctx = ctx
    this.canvasWidth = width
    this.canvasHeight = height

    this.player = new Tank({ x: width / 2 - 18, y: height - 56 }, 36, 24, '#4CAF50', 5, width)

    this.frameTimer = setInterval(() => this.tick(), Math.floor(1000 / this.targetFps))
  }

  stop() {
    if (this.frameTimer !== undefined) {
      clearInterval(this.frameTimer)
      this.frameTimer = undefined
    }
  }

  queueMoveLeft() {
    if (!this.player) return
    this.player.moveLeft()
  }

  queueMoveRight() {
    if (!this.player) return
    this.player.moveRight()
  }

  fire() {
    if (!this.player) return
    const b = this.player.fire()
    this.bullets.push(b)
  }

  private tick() {
    if (!this.ctx || !this.player) return
    const now = Date.now()

    // Spawn enemies
    if (now - this.lastEnemySpawnMs > this.enemySpawnIntervalMs) {
      this.spawnEnemy()
      this.lastEnemySpawnMs = now
    }

    // Update bullets
    this.bullets.forEach(b => b.update())
    this.bullets = this.bullets.filter(b => b.active && b.position.y + b.height >= 0)

    // Update enemies
    this.enemies.forEach(e => e.update())
    this.enemies = this.enemies.filter(e => e.active && e.position.y <= this.canvasHeight)

    // Collisions: bullets vs enemies
    for (let i = this.bullets.length - 1; i >= 0; i--) {
      const b = this.bullets[i]
      for (let j = this.enemies.length - 1; j >= 0; j--) {
        const e = this.enemies[j]
        if (this.rectsOverlap(b.getBounds(), e.getBounds())) {
          b.active = false
          e.active = false
          this.score += 10
          break
        }
      }
    }

    this.bullets = this.bullets.filter(b => b.active)
    this.enemies = this.enemies.filter(e => e.active)

    // Collisions: enemies reaching player line
    for (const e of this.enemies) {
      if (e.position.y + e.height >= this.player.position.y) {
        e.active = false
        this.lives = Math.max(0, this.lives - 1)
        if (this.lives === 0) {
          this.gameOver()
          return
        }
      }
    }

    // Render
    this.draw()
  }

  private draw() {
    if (!this.ctx || !this.player) return
    const ctx = this.ctx

    ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight)

    // Draw player
    this.player.draw(ctx)

    // Draw enemies
    this.enemies.forEach(e => e.draw(ctx))

    // Draw bullets
    this.bullets.forEach(b => b.draw(ctx))
  }

  private spawnEnemy() {
    const width = 34
    const height = 22
    const x = Math.floor(Math.random() * Math.max(1, this.canvasWidth - width))
    const y = -height
    const speed = 1.8 + Math.random() * 1.6
    const color = '#E53935'
    this.enemies.push(new Enemy({ x, y }, width, height, color, speed))
  }

  private rectsOverlap(a: { x: number, y: number, width: number, height: number }, b: { x: number, y: number, width: number, height: number }): boolean {
    return a.x < b.x + b.width &&
      a.x + a.width > b.x &&
      a.y < b.y + b.height &&
      a.y + a.height > b.y
  }

  private gameOver() {
    this.stop()
    // Clear remaining entities and reset some state visually
    if (!this.ctx) return
    this.ctx.fillStyle = 'rgba(0,0,0,0.6)'
    this.ctx.fillRect(0, 0, this.canvasWidth, this.canvasHeight)
    this.ctx.fillStyle = '#FFFFFF'
    this.ctx.font = '24px sans-serif'
    this.ctx.textAlign = 'center'
    this.ctx.fillText('GAME OVER', this.canvasWidth / 2, this.canvasHeight / 2 - 10)
    this.ctx.font = '16px sans-serif'
    this.ctx.fillText(`Score: ${this.score}`, this.canvasWidth / 2, this.canvasHeight / 2 + 18)
  }
}