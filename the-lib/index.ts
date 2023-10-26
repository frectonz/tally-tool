export class TallyTool {
  constructor(private apiDomain: string) {}

  namespace(namespace: string) {
    return new Namespace(this.apiDomain, namespace);
  }
}

export type Count = {
  tally: {
    id: number;
    namespace_id: number;
    name: string;
    count: number;
    created_at: Date;
    updated_at: Date;
  };
  completed: boolean;
};

function makeCount(data: any): Count {
  return {
    ...data,
    tally: {
      ...data.tally,
      created_at: new Date(data.tally.created_at),
      updated_at: new Date(data.tally.updated_at),
    },
  };
}

export class Namespace {
  constructor(
    private apiDomain: string,
    private namespace: string,
  ) {}

  tally(count: string) {
    return new Tally(this.apiDomain, this.namespace, count);
  }
}

const USER_ACTIONS_HEADER = "X-User-Actions" as const;
export class Tally {
  constructor(
    private apiDomain: string,
    private namespace: string,
    private count: string,
  ) {}

  async get() {
    const url = `${this.apiDomain}/namespaces/${this.namespace}/tallies/${this.count}`;

    const actions = getUserActions(this.namespace, this.count);
    const res = await fetch(url, {
      headers: { [USER_ACTIONS_HEADER]: actions.toString() },
    });

    const data = await res.json();
    return makeCount(data);
  }

  async increment() {
    const url = `${this.apiDomain}/namespaces/${this.namespace}/tallies/${this.count}?op=INC`;

    const actions = getUserActions(this.namespace, this.count);
    const res = await fetch(url, {
      method: "put",
      headers: { [USER_ACTIONS_HEADER]: actions.toString() },
    });
    incUserActions(this.namespace, this.count);

    const data = await res.json();
    return makeCount(data);
  }

  async decrement() {
    const url = `${this.apiDomain}/namespaces/${this.namespace}/tallies/${this.count}?op=DEC`;

    const actions = getUserActions(this.namespace, this.count);
    const res = await fetch(url, {
      method: "put",
      headers: { [USER_ACTIONS_HEADER]: actions.toString() },
    });
    decUserActions(this.namespace, this.count);

    const data = await res.json();
    return makeCount(data);
  }
}

function userActionsKey(namespace: string, count: string) {
  return `${namespace}:${count}:actions`;
}

function getUserActions(namespace: string, count: string) {
  return parseInt(localStorage.getItem(userActionsKey(namespace, count))!) || 0;
}

function incUserActions(namespace: string, count: string) {
  const actions = getUserActions(namespace, count) + 1;
  localStorage.setItem(userActionsKey(namespace, count), actions.toString());
}

function decUserActions(namespace: string, count: string) {
  const actions = getUserActions(namespace, count) - 1;
  localStorage.setItem(userActionsKey(namespace, count), actions.toString());
}
