package com.example.clockinwidget;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class TestActivity extends AppCompatActivity {

    private RecyclerView recyclerView;
    private TaskAdapter taskAdapter;
    private List<Task> tasks;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        tasks = new ArrayList<>();
        tasks.add(new Task("每天进步一点点", R.drawable.ic_crown, new boolean[]{false, false, false, true, false, false, false}, R.color.blue));
        tasks.add(new Task("早睡", R.drawable.ic_moon, new boolean[]{false, false, false, false, false, false, false}, R.color.purple));
        tasks.add(new Task("测试", R.drawable.ic_test, new boolean[]{false, false, false, false, false, false, false}, R.color.red));
        tasks.add(new Task("每天进步一点点", R.drawable.ic_crown, new boolean[]{false, false, false, false, false, false, false}, R.color.green));

        taskAdapter = new TaskAdapter(tasks);
        recyclerView.setAdapter(taskAdapter);
    }
}
