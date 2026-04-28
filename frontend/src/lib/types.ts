export type IssueStatus = "todo" | "in_progress" | "done" | "canceled";
export type IssuePriority = "no_priority" | "urgent" | "high" | "medium" | "low";

export interface Issue {
  id: number;
  identifier: string;
  title: string;
  description: string | null;
  status: IssueStatus;
  priority: IssuePriority;
}

export interface IssueInput {
  title: string;
  description?: string;
  status?: IssueStatus;
  priority?: IssuePriority;
}

export const STATUS_OPTIONS: { value: IssueStatus; label: string }[] = [
  { value: "todo", label: "Todo" },
  { value: "in_progress", label: "In Progress" },
  { value: "done", label: "Done" },
  { value: "canceled", label: "Canceled" },
];

export const PRIORITY_OPTIONS: { value: IssuePriority; label: string }[] = [
  { value: "no_priority", label: "No priority" },
  { value: "urgent", label: "Urgent" },
  { value: "high", label: "High" },
  { value: "medium", label: "Medium" },
  { value: "low", label: "Low" },
];
