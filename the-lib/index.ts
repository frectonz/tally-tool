export class TallyTool {
  constructor(private apiDomain: string) {}

  namespace(namespace: string) {
    return new Namespace(this.apiDomain, namespace);
  }
}

export type Count = {
  id: number;
  namespace_id: number;
  name: string;
  count: number;
  created_at: Date;
  updated_at: Date;
};

function makeCount(data: any): Count {
  return {
    id: data.id,
    namespace_id: data.namespace_id,
    name: data.name,
    count: data.count,
    created_at: new Date(data.created_at),
    updated_at: new Date(data.updated_at),
  };
}

export class Namespace {
  constructor(
    private apiDomain: string,
    private namespace: string,
  ) {}

  count(count: string) {
    return new Counter(this.apiDomain, this.namespace, count);
  }
}

export class Counter {
  constructor(
    private apiDomain: string,
    private namespace: string,
    private count: string,
  ) {}

  async increment() {
    const url = `${this.apiDomain}/namespaces/${this.namespace}/tallies/${this.count}?op=INC`;
    const res = await fetch(url, { method: "put" });
    const data = await res.json();
    return makeCount(data);
  }

  async decrement() {
    const url = `${this.apiDomain}/namespaces/${this.namespace}/tallies/${this.count}?op=DEC`;
    const res = await fetch(url, { method: "put" });
    const data = await res.json();
    return makeCount(data);
  }
}
