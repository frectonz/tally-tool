<script lang="ts">
  import Tally from "./lib/Tally.svelte";

  import fire from "./assets/fire.svg";
  import highVoltage from "./assets/high-voltage.svg";
  import beamingFace from "./assets/beaming-face.svg";

  const reactions = [
    { name: "fire", image: fire },
    { name: "high-voltage", image: highVoltage },
    { name: "beaming-face", image: beamingFace },
  ];
</script>

{#each reactions as reaction}
  <Tally {...reaction} />
{/each}
