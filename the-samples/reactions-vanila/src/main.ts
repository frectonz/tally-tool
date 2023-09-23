import "./style.css";
import { TallyTool } from "tally-tool";

const tally = new TallyTool("http://localhost:3000");
const reactions = tally.namespace("reactions");

const countDivs = document.querySelectorAll(
  "div[data-name]",
) as NodeListOf<HTMLDivElement>;

countDivs.forEach((countDiv) => {
  const count = countDiv.dataset.name!;
  const tally = reactions.tally(count);

  const countH2 = countDiv.querySelector("h2")!;
  const incrementBtn = countDiv.querySelector("button:nth-child(1)")!;
  const decrementBtn = countDiv.querySelector("button:nth-child(2)")!;

  tally.get().then((c) => {
    countH2.textContent = c.count.toString();
  });

  incrementBtn.addEventListener("click", () => {
    tally.increment().then((c) => {
      countH2.textContent = c.count.toString();
    });
  });

  decrementBtn.addEventListener("click", () => {
    tally.decrement().then((c) => {
      countH2.textContent = c.count.toString();
    });
  });
});
