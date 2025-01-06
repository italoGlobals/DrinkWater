import { Notifier } from "../../../core/notifier/notifier";

type AuthEventTypes = "USER_LOGGED_IN" | "USER_LOGGED_OUT";

interface AuthPayloads {
  USER_LOGGED_IN: { id: number; name: string };
  USER_LOGGED_OUT: { reason: string };
}

class AuthNotifier extends Notifier<AuthEventTypes, AuthPayloads> {}

export const authNotifier: AuthNotifier = new AuthNotifier();
