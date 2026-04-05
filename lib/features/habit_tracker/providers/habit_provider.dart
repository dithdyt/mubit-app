import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/habit_repository.dart';
import '../domain/habit_log.dart';
import '../../../main.dart'; // To access global isar instance

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(isar);
});

class HabitListNotifier extends FamilyAsyncNotifier<List<HabitLog>, DateTime> {
  late HabitRepository _repository;

  @override
  FutureOr<List<HabitLog>> build(DateTime arg) async {
    _repository = ref.watch(habitRepositoryProvider);
    return _fetchHabits(arg);
  }

  Future<List<HabitLog>> _fetchHabits(DateTime date) async {
    return await _repository.getHabitsByDate(date);
  }

  Future<void> toggleHabit(String type) async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.map((habit) {
          if (habit.habitType == type) {
            return HabitLog()
              ..id = habit.id
              ..date = habit.date
              ..habitType = habit.habitType
              ..isCompleted = !habit.isCompleted;
          }
          return habit;
        }).toList(),
      );
    }

    try {
      await _repository.toggleHabit(arg, type);
      state = AsyncValue.data(await _fetchHabits(arg));
    } catch (e, st) {
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      }
      state = AsyncValue.error(e, st);
    }
  }
}

final habitListProvider =
    AsyncNotifierProviderFamily<HabitListNotifier, List<HabitLog>, DateTime>(
  () => HabitListNotifier(),
);
