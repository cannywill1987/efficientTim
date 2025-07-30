package com.timespeed.time_hello.widgets;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.graphics.Paint;
import android.graphics.RectF;

class BackgroundDrawable extends Drawable {
    double percent = 0;
    int color;
    int cornerRadius = 0;
    public BackgroundDrawable(double percent, int color, int cornerRadius) {
        this.percent = percent;
        this.color = color;
        this.cornerRadius = cornerRadius;
    }

  @Override
public void draw(@NonNull Canvas canvas) {
    Paint paint = new Paint();
    paint.setColor(color);
    float width = canvas.getWidth() * (float) percent;
    float height = canvas.getHeight();
    RectF rect = new RectF(0, 0, width, height);
    canvas.drawRoundRect(rect, cornerRadius, cornerRadius, paint);
}

    @Override
    public void setAlpha(int alpha) {

    }

    @Override
    public void setColorFilter(@Nullable ColorFilter colorFilter) {

    }

    @Override
    public int getOpacity() {
        return 0;
    }
}
