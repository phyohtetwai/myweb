const screens = {
  intro: document.querySelector("#introScreen"),
  promise: document.querySelector("#promiseScreen"),
  game: document.querySelector("#gameScreen"),
  processing: document.querySelector("#processingScreen"),
  final: document.querySelector("#finalScreen"),
};

const modal = document.querySelector("#modal");
const modalIcon = document.querySelector("#modalIcon");
const modalTitle = document.querySelector("#modalTitle");
const modalMessage = document.querySelector("#modalMessage");
const modalButton = document.querySelector("#modalButton");
const modalClose = document.querySelector("#modalClose");

const gameField = document.querySelector("#gameField");
const missionCount = document.querySelector("#missionCount");
const missionProgress = document.querySelector("#missionProgress");
const comboText = document.querySelector("#comboText");
const crosshair = document.querySelector("#crosshair");
const photoInput = document.querySelector("#photoInput");
const memoryPhoto = document.querySelector("#memoryPhoto");
const photoPlaceholder = document.querySelector("#photoPlaceholder");

const goal = 10;
let score = 0;
let combo = 0;
let spawnTimer = null;
let comboResetTimer = null;
let gameFinished = false;

function showScreen(name) {
  Object.values(screens).forEach((screen) => screen.classList.remove("is-active"));
  screens[name].classList.add("is-active");
}

function resetIntroChoices() {
  document.querySelectorAll(".wrong-choice").forEach((button) => {
    button.classList.remove("is-hidden");
    button.disabled = false;
  });
}

function openModal({ icon = "✕", title, message, button = "OK", kiss = false }) {
  modalIcon.textContent = icon;
  modalIcon.classList.toggle("kiss", kiss);
  modalTitle.textContent = title;
  modalMessage.textContent = message;
  modalButton.textContent = button;
  modal.classList.add("show");
  modal.setAttribute("aria-hidden", "false");
}

function closeModal() {
  modal.classList.remove("show");
  modal.setAttribute("aria-hidden", "true");
}

function updateMission() {
  missionCount.textContent = `${score} / ${goal}`;
  missionProgress.style.width = `${(score / goal) * 100}%`;
}

function spawnHeart() {
  if (gameFinished) return;

  const heart = document.createElement("button");
  const isGold = Math.random() > 0.78;
  const left = Math.random() * 84 + 8;
  const life = Math.random() * 1.7 + 3.1;

  heart.type = "button";
  heart.className = `heart${isGold ? " gold" : ""}`;
  heart.style.left = `${left}%`;
  heart.style.top = "-30px";
  heart.style.setProperty("--life", `${life}s`);
  heart.setAttribute("aria-label", isGold ? "gold heart" : "heart");

  heart.addEventListener("pointerdown", (event) => {
    event.stopPropagation();
    collectHeart(heart, event.clientX, event.clientY, isGold);
  });

  gameField.appendChild(heart);
  window.setTimeout(() => heart.remove(), life * 1000);
}

function collectHeart(heart, x, y, isGold) {
  if (gameFinished || !heart.isConnected) return;

  heart.remove();
  score = Math.min(goal, score + (isGold ? 2 : 1));
  combo += 1;
  updateMission();
  showHitFx(x, y, isGold);
  showCombo();

  clearTimeout(comboResetTimer);
  comboResetTimer = window.setTimeout(() => {
    combo = 0;
  }, 1200);

  if (score >= goal) finishGame();
}

function showHitFx(x, y, isGold) {
  const ring = document.createElement("div");
  ring.className = "hit-ring";
  ring.style.left = `${x}px`;
  ring.style.top = `${y}px`;
  document.body.appendChild(ring);
  window.setTimeout(() => ring.remove(), 700);

  const points = document.createElement("div");
  points.className = "floating-score";
  points.textContent = isGold ? "+2 ULTRA GOLD!" : "အချစ်ရပြီ +1";
  points.style.left = `${x - 40}px`;
  points.style.top = `${y - 10}px`;
  document.body.appendChild(points);
  window.setTimeout(() => points.remove(), 950);
}

function showCombo() {
  if (combo < 2) return;
  comboText.textContent = `COMBO x${combo}!`;
  comboText.classList.remove("show");
  void comboText.offsetWidth;
  comboText.classList.add("show");
}

function startGame() {
  score = 0;
  combo = 0;
  gameFinished = false;
  gameField.innerHTML = "";
  updateMission();
  showScreen("game");

  clearInterval(spawnTimer);
  spawnTimer = window.setInterval(spawnHeart, 520);
  for (let i = 0; i < 6; i += 1) {
    window.setTimeout(spawnHeart, i * 220);
  }
}

function finishGame() {
  gameFinished = true;
  clearInterval(spawnTimer);
  gameField.innerHTML = "";
  comboText.textContent = "CINEMATIC FINISH ✨";
  comboText.classList.remove("show");
  void comboText.offsetWidth;
  comboText.classList.add("show");

  window.setTimeout(() => showScreen("processing"), 1000);
  window.setTimeout(() => showScreen("final"), 2600);
}

document.querySelectorAll(".wrong-choice").forEach((button) => {
  button.addEventListener("click", () => {
    button.classList.add("is-hidden");
    button.disabled = true;
    openModal({
      title: "Error တက်နေပါတယ်",
      message: "အခြားတစ်ခုကို နှိပ်ပါ။ ဒီခလုတ်ကို ဖယ်လိုက်ပြီနော်။",
      button: "OK",
    });
  });
});

document.querySelector(".correct-choice").addEventListener("click", () => {
  startGame();
});

document.querySelector("#startGameBtn").addEventListener("click", startGame);
document.querySelector("#homeBtn").addEventListener("click", () => {
  resetIntroChoices();
  showScreen("intro");
});
document.querySelector("#muahBtn").addEventListener("click", () => {
  openModal({
    icon: "♡",
    title: "အနမ်းရပါပြီ",
    message: "Mission completed. Love accepted.",
    button: "နောက်တစ်ခေါက်",
    kiss: true,
  });
});

modalClose.addEventListener("click", closeModal);
modalButton.addEventListener("click", closeModal);
modal.addEventListener("click", (event) => {
  if (event.target === modal) closeModal();
});

document.addEventListener("pointermove", (event) => {
  crosshair.style.left = `${event.clientX}px`;
  crosshair.style.top = `${event.clientY}px`;
});

photoInput.addEventListener("change", () => {
  const file = photoInput.files?.[0];
  if (!file) return;

  const reader = new FileReader();
  reader.addEventListener("load", () => {
    memoryPhoto.src = reader.result;
    memoryPhoto.style.display = "block";
    photoPlaceholder.style.display = "none";
  });
  reader.readAsDataURL(file);
});
