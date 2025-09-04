// Mock WebSocket server for development/testing
// This simulates real-time seat updates for demonstration purposes

export class MockWebSocketServer {
  private clients: Set<WebSocket> = new Set()
  private eventSeats: Map<string, Map<string, any>> = new Map()
  private updateInterval: NodeJS.Timeout | null = null

  constructor() {
    this.startRandomUpdates()
  }

  addClient(ws: WebSocket, eventId: string) {
    this.clients.add(ws)

    ws.addEventListener("close", () => {
      this.clients.delete(ws)
    })

    ws.addEventListener("message", (event) => {
      this.handleMessage(ws, JSON.parse(event.data), eventId)
    })

    // Send initial connection confirmation
    this.sendToClient(ws, {
      type: "connected",
      payload: { eventId },
    })
  }

  private handleMessage(ws: WebSocket, message: any, eventId: string) {
    switch (message.type) {
      case "reserve_seats":
        this.handleReserveSeats(message.payload, eventId)
        break
      case "release_seats":
        this.handleReleaseSeats(message.payload, eventId)
        break
      case "occupy_seats":
        this.handleOccupySeats(message.payload, eventId)
        break
      case "heartbeat":
        this.sendToClient(ws, { type: "heartbeat" })
        break
      case "heartbeat_response":
        // Client responded to heartbeat
        break
    }
  }

  private handleReserveSeats(payload: any, eventId: string) {
    const { seatIds, userId } = payload

    seatIds.forEach((seatId: string) => {
      this.updateSeatStatus(eventId, seatId, "reserved", userId)
    })

    this.broadcastSeatUpdate(
      eventId,
      seatIds.map((seatId: string) => ({
        seatId,
        status: "reserved" as const,
        userId,
        reservedUntil: new Date(Date.now() + 15 * 60 * 1000).toISOString(),
      })),
    )
  }

  private handleReleaseSeats(payload: any, eventId: string) {
    const { seatIds, userId } = payload

    seatIds.forEach((seatId: string) => {
      this.updateSeatStatus(eventId, seatId, "available")
    })

    this.broadcastSeatUpdate(
      eventId,
      seatIds.map((seatId: string) => ({
        seatId,
        status: "available" as const,
      })),
    )
  }

  private handleOccupySeats(payload: any, eventId: string) {
    const { seatIds, userId, transactionId } = payload

    seatIds.forEach((seatId: string) => {
      this.updateSeatStatus(eventId, seatId, "occupied", userId)
    })

    this.broadcastSeatUpdate(
      eventId,
      seatIds.map((seatId: string) => ({
        seatId,
        status: "occupied" as const,
        userId,
      })),
    )
  }

  private updateSeatStatus(eventId: string, seatId: string, status: string, userId?: string) {
    if (!this.eventSeats.has(eventId)) {
      this.eventSeats.set(eventId, new Map())
    }

    const eventSeatsMap = this.eventSeats.get(eventId)!
    eventSeatsMap.set(seatId, { status, userId, updatedAt: Date.now() })
  }

  private broadcastSeatUpdate(eventId: string, updates: any[]) {
    const message = {
      type: "seat_update",
      payload: {
        eventId,
        updates,
        timestamp: Date.now(),
      },
    }

    this.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        this.sendToClient(client, message)
      }
    })
  }

  private sendToClient(ws: WebSocket, message: any) {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(message))
    }
  }

  private startRandomUpdates() {
    // Simulate random seat updates every 10-30 seconds
    this.updateInterval = setInterval(
      () => {
        this.generateRandomUpdate()
      },
      Math.random() * 20000 + 10000,
    )
  }

  private generateRandomUpdate() {
    const eventIds = ["1", "2", "3"] // Mock event IDs
    const eventId = eventIds[Math.floor(Math.random() * eventIds.length)]

    // Generate random seat updates
    const updates = []
    const numUpdates = Math.floor(Math.random() * 3) + 1

    for (let i = 0; i < numUpdates; i++) {
      const seatId = `mock_seat_${Math.floor(Math.random() * 100)}`
      const statuses = ["available", "occupied", "reserved"]
      const status = statuses[Math.floor(Math.random() * statuses.length)]

      updates.push({
        seatId,
        status,
        userId: status !== "available" ? `user_${Math.random().toString(36).substr(2, 9)}` : undefined,
      })
    }

    this.broadcastSeatUpdate(eventId, updates)
  }

  stop() {
    if (this.updateInterval) {
      clearInterval(this.updateInterval)
      this.updateInterval = null
    }

    this.clients.forEach((client) => {
      client.close()
    })
    this.clients.clear()
  }
}

// Export singleton instance for development
let mockServer: MockWebSocketServer | null = null

export function getMockWebSocketServer(): MockWebSocketServer {
  if (!mockServer) {
    mockServer = new MockWebSocketServer()
  }
  return mockServer
}
