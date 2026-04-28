"use client";

import type { Issue, IssueStatus, IssuePriority } from "@/lib/types";

const STATUS_STYLES: Record<IssueStatus, { dot: string; label: string }> = {
  todo: { dot: "bg-zinc-500", label: "Todo" },
  in_progress: { dot: "bg-yellow-500", label: "In Progress" },
  done: { dot: "bg-emerald-500", label: "Done" },
  canceled: { dot: "bg-zinc-700", label: "Canceled" },
};

const PRIORITY_LABEL: Record<IssuePriority, string> = {
  no_priority: "—",
  urgent: "Urgent",
  high: "High",
  medium: "Medium",
  low: "Low",
};

const PRIORITY_COLOR: Record<IssuePriority, string> = {
  no_priority: "text-[var(--muted)]",
  urgent: "text-red-400",
  high: "text-orange-400",
  medium: "text-[var(--foreground)]",
  low: "text-[var(--muted)]",
};

interface Props {
  issue: Issue;
  onEdit: (issue: Issue) => void;
  onDelete: (id: number) => void;
}

export default function IssueRow({ issue, onEdit, onDelete }: Props) {
  const status = STATUS_STYLES[issue.status];
  return (
    <div
      onClick={() => onEdit(issue)}
      className="group flex items-center gap-3 px-4 py-2.5 border-b border-[var(--border)] hover:bg-[var(--surface-2)] cursor-pointer"
    >
      <span className={`w-2 h-2 rounded-full ${status.dot}`} />
      <span className="text-xs text-[var(--muted)] font-mono w-20 shrink-0">
        {issue.identifier}
      </span>
      <span className="flex-1 text-sm truncate">{issue.title}</span>
      <span className={`text-xs ${PRIORITY_COLOR[issue.priority]} w-16 text-right`}>
        {PRIORITY_LABEL[issue.priority]}
      </span>
      <span className="text-xs text-[var(--muted)] w-24 text-right">
        {status.label}
      </span>
      <button
        onClick={(e) => {
          e.stopPropagation();
          if (confirm(`Delete ${issue.identifier}?`)) onDelete(issue.id);
        }}
        className="opacity-0 group-hover:opacity-100 text-xs text-red-400 hover:text-red-300 px-2"
      >
        Delete
      </button>
    </div>
  );
}
