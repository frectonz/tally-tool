import "./style.css";
import { TallyTool } from "tally-tool";

const tally = new TallyTool("http://localhost:3000");
const reactions = tally.namespace("reactions");

const countDivs = document.querySelectorAll(
  "div[data-name]",
) as NodeListOf<HTMLDivElement>;

countDivs.forEach((countDiv) => {
  const count = countDiv.dataset.name!;
  const thisCount = reactions.count(count);

  const countH2 = countDiv.querySelector("h2")!;
  const incrementBtn = countDiv.querySelector("button:nth-child(1)")!;
  const decrementBtn = countDiv.querySelector("button:nth-child(2)")!;

  thisCount.get().then((c) => {
    countH2.textContent = c.count.toString();
  });

  incrementBtn.addEventListener("click", () => {
    thisCount.increment().then((c) => {
      countH2.textContent = c.count.toString();
    });
  });

  decrementBtn.addEventListener("click", () => {
    thisCount.decrement().then((c) => {
      countH2.textContent = c.count.toString();
    });
  });
});
