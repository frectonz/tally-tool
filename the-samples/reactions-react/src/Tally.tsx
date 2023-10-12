import { TallyTool } from "tally-tool";
import { useQuery, useMutation, useQueryClient } from "react-query";

const tally = new TallyTool(import.meta.env.VITE_APP_URL);
const reactions = tally.namespace("reactions");

type TallyProps = {
  name: string;
  image: string;
};

function Tally({ name, image }: TallyProps) {
  const tally = reactions.tally(name);

  const queryClient = useQueryClient();
  const { data } = useQuery(["reactions", name], () => tally.get());

  const inc = useMutation(() => tally.increment(), {
    onSuccess: (data) => {
      queryClient.setQueryData(["reactions", name], data);
    },
  });

  const dec = useMutation(() => tally.decrement(), {
    onSuccess: (data) => {
      queryClient.setQueryData(["reactions", name], data);
    },
  });

  if (!data) {
    return null;
  }

  return (
    <div className="card">
      <img src={image} />
      <h2>{data.tally.count}</h2>
      <div className="btns">
        <button disabled={data.completed} onClick={() => inc.mutate()}> + </button>
        <button disabled={data.completed} onClick={() => dec.mutate()}> - </button>
      </div>
    </div>
  );
}

export default Tally;
