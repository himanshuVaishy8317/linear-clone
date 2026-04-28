import axios from "axios";
import { API_URL } from "./constants";
import type { Issue, IssueInput } from "./types";

const api = axios.create({
  baseURL: API_URL,
  headers: { "Content-Type": "application/json" },
});

export const issuesApi = {
  list: () => api.get<{ data: Issue[] }>("/issues"),

  get: (id: number) => api.get<{ data: Issue }>(`/issues/${id}`),

  create: (input: IssueInput) =>
    api.post<{ data: Issue }>("/issues", { issue: input }),

  update: (id: number, input: Partial<IssueInput>) =>
    api.put<{ data: Issue }>(`/issues/${id}`, { issue: input }),

  remove: (id: number) => api.delete(`/issues/${id}`),
};

export default api;
