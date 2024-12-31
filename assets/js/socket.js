import { Socket } from "phoenix";

// Connect to the WebSocket endpoint
const socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

// Join the room channel
const roomId = window.location.pathname.split("/rooms/")[1];
const channel = socket.channel(`room:${roomId}`, {});

// DOM elements
const questionEl = document.getElementById("question");
const answersEl = document.getElementById("answers");
const submitBtn = document.getElementById("submit-answer");
const resultsEl = document.getElementById("results");

// Handle incoming broadcasts
channel.on("vote:results", (payload) => {
  resultsEl.innerText = `Correct Answer: ${payload.correct_answer}`;
});

// Join the channel
channel
  .join()
  .receive("ok", () => {
    console.log(`Joined room: ${roomId}`);
  })
  .receive("error", (resp) => {
    console.error("Unable to join", resp);
  });

// Example: Simulate a question
function showQuestion(question, options) {
  questionEl.innerText = question;
  answersEl.innerHTML = "";
  options.forEach((option, idx) => {
    const li = document.createElement("li");
    li.innerText = option;
    li.addEventListener("click", () => {
      channel.push("vote", { room_id: roomId, answer: idx });
    });
    answersEl.appendChild(li);
  });
}

// Simulate a question after 2 seconds
setTimeout(() => {
  showQuestion("What is 2 + 2?", ["1", "2", "3", "4"]);
  submitBtn.disabled = false;
}, 2000);
