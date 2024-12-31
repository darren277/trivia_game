// ----- Phoenix defaults for HTML forms, LiveView, etc. -----
import "phoenix_html"
import { Socket as PhoenixSocket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Grabs the CSRF token from your HTML meta tag
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content")

// Sets up the Phoenix LiveView (if you're using LiveView)
let liveSocket = new LiveSocket("/live", PhoenixSocket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
})

// Optional topbar progress indicator
topbar.config({ barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Connect LiveView (if any are present)
liveSocket.connect()
window.liveSocket = liveSocket

// ----- Start of YOUR Channel logic -----

import { Socket } from "phoenix" // We can rename if desired, but "Socket" is typical

// 1) Identify the room ID from the URL
const roomId = window.location.pathname.split("/rooms/")[1] || "default"

// 2) Create & connect your Phoenix socket to "/socket"
const socket = new Socket("/socket", { params: { token: window.userToken } })
socket.connect()

// 3) Join the room channel, e.g. "room:1"
const channel = socket.channel(`room:${roomId}`, {})

// 4) Grab DOM elements
const questionEl = document.getElementById("question")
const answersEl  = document.getElementById("answers")
const resultsEl  = document.getElementById("results")
const submitBtn  = document.getElementById("submit-answer")
const startBtn   = document.getElementById("start-question")

// 5) Handle events from the server ("new_question", "vote:results", etc.)

// Listen for a new question being broadcast by the server
channel.on("new_question", (payload) => {
  console.log("Received new_question:", payload)

  // Clear previous results
  resultsEl.innerText = ""

  // Update the question text
  questionEl.innerText = payload.question

  // Render the multiple-choice answers
  answersEl.innerHTML = "" // Clear any old choices
  payload.choices.forEach((choice, idx) => {
    let li = document.createElement("li")
    li.innerText = choice
    li.addEventListener("click", () => {
      // Example: push a "vote" event with the chosen answer
      channel.push("vote", { room_id: roomId, answer: idx })
    })
    answersEl.appendChild(li)
  })
})

// Listen for vote results
channel.on("vote:results", (payload) => {
  resultsEl.innerText = `Correct Answer: ${payload.correct_answer}`
})

// 6) Join the channel & log success/failure
channel.join()
  .receive("ok",    () => console.log(`Joined room:${roomId} successfully`))
  .receive("error", (resp) => console.error("Failed to join room", resp))

// 7) If you have a "Start Question" button, push a "start_question" event
if (startBtn) {
  startBtn.addEventListener("click", () => {
    channel.push("start_question", {
      question: "What is the capital of France?",
      choices: ["Berlin", "London", "Paris", "Madrid"]
    })
  })
}

// 8) Example function to show a question on page load or after a delay
function showQuestion(question, options) {
  questionEl.innerText = question
  answersEl.innerHTML = ""

  options.forEach((option, idx) => {
    let li = document.createElement("li")
    li.innerText = option
    li.addEventListener("click", () => {
      channel.push("vote", { room_id: roomId, answer: idx })
    })
    answersEl.appendChild(li)
  })
}

// 9) Example: Simulate a question 2 seconds after page load
setTimeout(() => {
  showQuestion("What is 2 + 2?", ["1", "2", "3", "4"])
  if (submitBtn) submitBtn.disabled = false
}, 2000)
