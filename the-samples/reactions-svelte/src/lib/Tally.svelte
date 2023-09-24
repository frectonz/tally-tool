<script lang="ts">
  import type { Count } from "tally-tool";
  import { TallyTool } from "tally-tool";

  export let name: string;
  export let image: string;

  const tally = new TallyTool("http://localhost:3000")
    .namespace("reactions")
    .tally(name);

  let count = "";
  let completed = false;

  const update = (c: Count) => {
    count = c.tally.count.toString();
    completed = c.completed;
  };

  const getCount = () => tally.get().then(update);
  const incCount = () => tally.increment().then(update);
  const decCount = () => tally.decrement().then(update);

  getCount();
</script>

  <div class="card">
    <img src={image} alt={name} />

    <h2>{count}</h2>

    <div class="btns">
      <button disabled={completed} on:click={incCount}> + </button>
      <button disabled={completed} on:click={decCount}> - </button>
    </div>
  </div>
