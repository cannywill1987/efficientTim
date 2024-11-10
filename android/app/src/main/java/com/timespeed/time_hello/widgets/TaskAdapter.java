package com.example.clockinwidget;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.TaskViewHolder> {

    private List<Task> tasks;

    public TaskAdapter(List<Task> tasks) {
        this.tasks = tasks;
    }

    @NonNull
    @Override
    public TaskViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.task_item, parent, false);
        return new TaskViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull TaskViewHolder holder, int position) {
        Task task = tasks.get(position);
        holder.bind(task);
    }

    @Override
    public int getItemCount() {
        return tasks.size();
    }

    class TaskViewHolder extends RecyclerView.ViewHolder {
        private ImageView iconView;
        private TextView titleView;
        private ViewGroup statusContainer;

        public TaskViewHolder(@NonNull View itemView) {
            super(itemView);
            iconView = itemView.findViewById(R.id.icon);
            titleView = itemView.findViewById(R.id.title);
            statusContainer = itemView.findViewById(R.id.status_container);
        }

        public void bind(Task task) {
            iconView.setImageResource(task.getIconResId());
            titleView.setText(task.getTitle());

            // 清空状态容器并重新添加状态按钮
            statusContainer.removeAllViews();
            boolean[] status = task.getStatus();
            Context context = statusContainer.getContext();

            for (int i = 0; i < status.length; i++) {
                final int dayIndex = i;
                View statusView = new View(context);
                statusView.setLayoutParams(new ViewGroup.LayoutParams(50, 50)); // 设置每个状态方块的大小
                int color = status[dayIndex] ? task.getColorResId() : android.R.color.darker_gray;
                statusView.setBackgroundColor(ContextCompat.getColor(context, color));
                statusView.setOnClickListener(v -> {
                    task.toggleStatus(dayIndex);
                    notifyItemChanged(getAdapterPosition());
                });
                statusContainer.addView(statusView);
            }
        }
    }
}
