# 12 V → 5 V Regulator — Altium Designer

An Altium Designer PCB project for a 12 V → 5 V regulator board. Includes the full schematic, two-layer PCB layout, BOM, project history, and CAM outputs ready for fabrication.

> Course: ELEE 4180 / Engineering Design — PCB design module.
> Tool: Altium Designer.

---

## Project Structure

| File / Folder | Description |
|---|---|
| `12v to 5v_Regulator.PrjPcb` | Altium project file (open this first) |
| `12v to 5v_Regulator.PrjPcbStructure` | Project structure metadata |
| `Sheet1.SchDoc` | Schematic capture |
| `12v to 5v_Regulator.PcbDoc` | PCB layout |
| `12v to 5v_Regulator.BomDoc` | Bill of materials |
| `__Previews/` | Auto-generated schematic / layout previews |
| `History/` | Altium revision history |
| `Project Logs for 12v to 5v_Regulator/` | Compile, ERC, DRC, and output-generation logs |
| `Project Outputs for 12v to 5v_Regulator/` | Generated CAM / Gerber / drill files (when present) |

---

## How to Open

1. Install **Altium Designer**.
2. Open `12v to 5v_Regulator.PrjPcb` from File → Open Project.
3. Use the *Projects* panel to switch between the schematic (`Sheet1.SchDoc`), the layout (`12v to 5v_Regulator.PcbDoc`), and the BOM (`12v to 5v_Regulator.BomDoc`).
4. Run **Validate Project** before generating outputs to confirm ERC/DRC are clean against the active rule set.

---

## Notes

- The board steps a 12 V automotive / bench supply down to a regulated 5 V rail suitable for low-power digital logic.
- Output protection, decoupling, and thermal considerations live in `Sheet1.SchDoc`; review the BOM for the exact regulator IC and passives used.
