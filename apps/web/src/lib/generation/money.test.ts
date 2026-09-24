import { describe, expect, it } from "vitest";

import { usd } from "./money";

describe("dollars", () => {
  it("never shows a cheap line as free", () => {
    expect(usd(0.0042)).toBe("$0.0042");
    expect(usd(0.000015)).toBe("$0.000015");
  });

  it("shows cents once there are any", () => {
    expect(usd(1.234)).toBe("$1.23");
    expect(usd(0.5)).toBe("$0.50");
  });

  it("shows a free model as nothing, exactly", () => {
    expect(usd(0)).toBe("$0");
  });
});
