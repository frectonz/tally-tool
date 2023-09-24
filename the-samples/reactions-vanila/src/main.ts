import "./style.css";
import { TallyTool, Count } from "tally-tool";

const tally = new TallyTool("http://localhost:3000");
const reactions = tally.namespace("reactions");

const countDivs = document.querySelectorAll(
  "div[data-name]",
) as NodeListOf<HTMLDivElement>;

countDivs.forEach((countDiv) => {
  const count = countDiv.dataset.name!;
  const tally = reactions.tally(count);

  const countH2 = countDiv.querySelector("h2")!;
  const incrementBtn = countDiv.querySelector(
    "button:nth-child(1)",
  )! as HTMLButtonElement;
  const decrementBtn = countDiv.querySelector(
    "button:nth-child(2)",
  )! as HTMLButtonElement;

  const update = (c: Count) => {
    countH2.textContent = c.tally.count.toString();
    incrementBtn.disabled = c.completed;
    decrementBtn.disabled = c.completed;
  };

  tally.get().then(update);

  incrementBtn.addEventListener("click", () => {
    tally.increment().then(update);
  });

  decrementBtn.addEventListener("click", () => {
    tally.decrement().then(update);
  });
});
