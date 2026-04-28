"use client";

import { useState, useEffect, useCallback } from "react";
import { issuesApi } from "@/lib/api";
import type { Issue, IssueInput } from "@/lib/types";
import IssueRow from "@/components/IssueRow";
import IssueForm from "@/components/IssueForm";

export default function HomePage() {
  const [issues, setIssues] = useState<Issue[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<Issue | null>(null);

  const load = useCallback(async () => {
    try {
      setLoading(true);
      const res = await issuesApi.list();
      setIssues(res.data.data);
      setError(null);
    } catch (e: unknown) {
      const msg = e instanceof Error ? e.message : "Failed to load issues";
      setError(msg);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  function openCreate() {
    setEditing(null);
    setShowForm(true);
  }

  function openEdit(issue: Issue) {
    setEditing(issue);
    setShowForm(true);
  }

  function closeForm() {
    setShowForm(false);
    setEditing(null);
  }

  async function handleSubmit(values: IssueInput) {
    if (editing) {
      const res = await issuesApi.update(editing.id, values);
      setIssues((prev) => prev.map((i) => (i.id === editing.id ? res.data.data : i)));
    } else {
      const res = await issuesApi.create(values);
      setIssues((prev) => [res.data.data, ...prev]);
    }
    closeForm();
  }

  async function handleDelete(id: number) {
    await issuesApi.remove(id);
    setIssues((prev) => prev.filter((i) => i.id !== id));
  }

  return (
    <div className="min-h-screen flex flex-col">
      <header className="flex items-center justify-between px-6 py-4 border-b border-[var(--border)]">
        <div className="flex items-center gap-2">
          <div className="w-6 h-6 rounded-md bg-[var(--accent)] flex items-center justify-center text-xs font-bold text-white">
            L
          </div>
          <h1 className="text-sm font-semibold">Linear Clone</h1>
          <span className="text-xs text-[var(--muted)] ml-2">All issues</span>
        </div>
        <button
          onClick={openCreate}
          className="px-3 py-1.5 text-sm bg-[var(--accent)] text-white rounded-md hover:opacity-90"
        >
          + New issue
        </button>
      </header>

      <main className="flex-1">
        {loading && (
          <div className="p-6 text-sm text-[var(--muted)]">Loading...</div>
        )}
        {error && <div className="p-6 text-sm text-red-400">{error}</div>}
        {!loading && !error && issues.length === 0 && (
          <div className="p-12 text-center">
            <p className="text-[var(--muted)] text-sm mb-4">No issues yet.</p>
            <button
              onClick={openCreate}
              className="px-3 py-1.5 text-sm bg-[var(--accent)] text-white rounded-md hover:opacity-90"
            >
              Create your first issue
            </button>
          </div>
        )}
        {!loading && !error && issues.length > 0 && (
          <div>
            <div className="px-4 py-2 text-xs text-[var(--muted)] border-b border-[var(--border)] bg-[var(--surface)]">
              {issues.length} issue{issues.length === 1 ? "" : "s"}
            </div>
            {issues.map((issue) => (
              <IssueRow
                key={issue.id}
                issue={issue}
                onEdit={openEdit}
                onDelete={handleDelete}
              />
            ))}
          </div>
        )}
      </main>

      {showForm && (
        <div
          className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4"
          onClick={closeForm}
        >
          <div
            className="bg-[var(--surface)] border border-[var(--border)] rounded-lg w-full max-w-lg p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-base font-semibold mb-4">
              {editing ? `Edit ${editing.identifier}` : "New issue"}
            </h2>
            <IssueForm
              initial={editing}
              onSubmit={handleSubmit}
              onCancel={closeForm}
            />
          </div>
        </div>
      )}
    </div>
  );
}
