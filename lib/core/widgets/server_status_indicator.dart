import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/server_health_cubit.dart';

class ServerStatusIndicator extends StatelessWidget {
  const ServerStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerHealthCubit, ServerHealthState>(
      builder: (context, state) {
        Color dotColor;
        String text;
        bool isWakingUp = state is ServerHealthWaking;

        if (state is ServerHealthAwake) {
          dotColor = Colors.green;
          text = 'Online';
        } else if (state is ServerHealthWaking) {
          dotColor = Colors.amber;
          text = 'Waking up...';
        } else {
          // ServerSleeping
          dotColor = Colors.red;
          text = 'Wake Server';
        }

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isWakingUp
              ? null
              : () => context.read<ServerHealthCubit>().wakeServer(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: dotColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dotColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isWakingUp)
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.amber,
                    ),
                  )
                else
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dotColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
