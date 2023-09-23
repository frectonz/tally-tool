import { QueryClient, QueryClientProvider } from "react-query";
import Tally from "./Tally";

import fire from "./assets/fire.svg";
import highVoltage from "./assets/high-voltage.svg";
import beamingFace from "./assets/beaming-face.svg";

const reactions = [
  { name: "fire", image: fire },
  { name: "high-voltage", image: highVoltage },
  { name: "beaming-face", image: beamingFace },
];

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      {reactions.map((r) => (
        <Tally key={r.name} name={r.name} image={r.image} />
      ))}
    </QueryClientProvider>
  );
}

export default App;
