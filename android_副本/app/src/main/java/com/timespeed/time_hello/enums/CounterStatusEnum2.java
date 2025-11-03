package com.timespeed.time_hello.enums;

public enum CounterStatusEnum2 {
    focusing (0),
    pausingFucusing (1),
    relaxing (2),
    waitingToFocus (3),
    waitingToStartRelaxing (4),
    pausingRelaixing(5),
    none(6),
    finishActivity(7);
    private final int index;

     CounterStatusEnum2(int index) {
        this.index = index;
    }

    public static CounterStatusEnum2 getCounterStatusEnumFromIndex(int index) {
        switch (index) {
            case 0:
                return CounterStatusEnum2.focusing;
            case 1:
                return CounterStatusEnum2.pausingFucusing;
            case 2:
                return CounterStatusEnum2.relaxing;
            case 3:
                return CounterStatusEnum2.waitingToFocus;
            case 4:
                return CounterStatusEnum2.waitingToStartRelaxing;
            case 5:
                return CounterStatusEnum2.pausingRelaixing;
            case 6:
                return CounterStatusEnum2.none;
            case 7:
                return CounterStatusEnum2.finishActivity;
            default:
                throw new RuntimeException("Unknown index:" + index);
        }
    }


    public int index() {
        return index;
    }

}