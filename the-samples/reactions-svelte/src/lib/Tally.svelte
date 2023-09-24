<script lang="ts">
  import { TallyTool } from "tally-tool";

  export let name: string;
  export let image: string;

  const tally = new TallyTool("http://localhost:3000")
    .namespace("reactions")
    .tally(name);

  const getCount = () => tally.get().then(c => c.count);
  const incCount = () => tally.increment().then(c => c.count);
  const decCount = () => tally.decrement().then(c => c.count);

  let countPromise = getCount();
</script>

  <div class="card">
    <img src={image} alt={name} />

    <h2>
      {#await countPromise}
        _
      {:then count}
        {count}
      {/await}
    </h2>

    <div class="btns">
      <button on:click={() => { countPromise = incCount(); }}> + </button>
      <button on:click={() => { countPromise = decCount(); }}> - </button>
    </div>
  </div>
