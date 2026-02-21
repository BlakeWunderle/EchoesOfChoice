using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading;

namespace EchoesOfChoice.Battles
{
    public abstract class Battle
    {
        public static bool IsSilent { get; set; }

        public Battle(List<BaseFighter> units)
        {
            Units = units;

            foreach (var unit in Units)
            {
                unit.Health = unit.MaxHealth;
                unit.Mana = unit.MaxMana;

                foreach (var mod in unit.ModifiedStats)
                {
                    ModifyStats(unit, mod.Stat, mod.Modifier, !mod.IsNegative);
                }
                unit.ModifiedStats.Clear();
            }

            DeadUnits = new List<BaseFighter>();
        }

        public List<BaseFighter> Enemies { get; protected set; }
        public List<BaseFighter> Units { get; protected set; }
        public List<BaseFighter> DeadUnits { get; protected set; }

        private readonly List<BaseFighter> _actingUnits = new List<BaseFighter>(8);
        private readonly List<Ability> _affordable = new List<Ability>(8);
        private readonly List<Ability> _healAbilities = new List<Ability>(4);
        private readonly List<Ability> _buffAbilities = new List<Ability>(4);
        private readonly List<Ability> _offensiveAbilities = new List<Ability>(4);
        public void CheckForDeath()
        {
            var unitsToRemove = new List<int>();
            var enemiesToRemove = new List<int>();

            for (int i = 0; i < Units.Count; i++)
            {
                if (Units[i].Health <= 0)
                {
                    if (!IsSilent)
                    {
                        Console.WriteLine();
                        Console.WriteLine($"{Units[i].CharacterName} the {Units[i].CharacterType} has been knocked out.");
                        CombatPause();
                    }
                    unitsToRemove.Add(i);
                }
            }

            for (int i = 0; i < Enemies.Count; i++)
            {
                if (Enemies[i].Health <= 0)
                {
                    if (!IsSilent)
                    {
                        Console.WriteLine();
                        Console.WriteLine($"{Enemies[i].CharacterName} the {Enemies[i].CharacterType} has been knocked out.");
                        CombatPause();
                    }
                    enemiesToRemove.Add(i);
                }
            }

            for (int i = 0; i < unitsToRemove.Count; i++)
            {
                var unit = unitsToRemove[i] - i;
                DeadUnits.Add(Units[unit]);
                Units.RemoveAt(unit);
            }

            for (int i = 0; i < enemiesToRemove.Count; i++)
            {
                var enemy = enemiesToRemove[i] - i;
                Enemies.RemoveAt(enemy);
            }
        }

        public bool BeginBattle()
        {
            while (Units.Count > 0 && Enemies.Count > 0)
            {
                UpdateTurn();

                _actingUnits.Clear();
                for (int idx = 0; idx < Units.Count; idx++)
                    if (Units[idx].TurnCalculation >= 100)
                        _actingUnits.Add(Units[idx]);
                for (int idx = 0; idx < Enemies.Count; idx++)
                    if (Enemies[idx].TurnCalculation >= 100)
                        _actingUnits.Add(Enemies[idx]);

                if (_actingUnits.Count > 0)
                {
                    _actingUnits.Sort((a, b) => b.TurnCalculation.CompareTo(a.TurnCalculation));
                    foreach (var actingUnit in _actingUnits)
                    {
                        //Unit cannot act if they are dead
                        if(actingUnit.Health <= 0)
                        {
                            CheckForDeath();
                            continue;
                        }

                        if (!IsSilent)
                        {
                            Console.WriteLine();
                            if (actingUnit.CharacterName.EndsWith('s'))
                            {
                                Console.WriteLine($"It is {actingUnit.CharacterName}' turn.");
                            }
                            else
                            {
                                Console.WriteLine($"It is {actingUnit.CharacterName}'s turn.");
                            }
                        }

                        ResetModifiedStat(actingUnit);

                        if (actingUnit.IsUserControlled)
                        {
                            var line = DetermineAction(actingUnit);

                            while (line == "stats")
                            {
                                ShowStatsMenu(Units, Enemies);
                                line = DetermineAction(actingUnit);
                            }

                            if (line == "attack")
                            {
                                var attackedEnemy = GetTauntTarget(Enemies) ?? ChooseAffectedUnit(Enemies);
                                PhysicalAttack(actingUnit, attackedEnemy);
                            }
                            else if (line == "ability")
                            {
                                var abilityToUse = DetermineAbility(actingUnit);
                                PlayerUseAbility(actingUnit, abilityToUse);
                            }
                        }
                        else
                        {
                            var isPartyMember = Units.Contains(actingUnit);
                            var targets = isPartyMember ? Enemies : Units;
                            var allies = isPartyMember ? Units : Enemies;
                            ExecuteAITurn(actingUnit, targets, allies);
                        }

                        CheckForDeath();

                        if(Units.Count == 0 || Enemies.Count == 0)
                        {
                            break;
                        }
                    }

                    ResetTurns();
                }
            }

            if(Enemies.Count > 0)
            {
                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine("The party has been defeated...");
                    CombatPause();
                }
                return true;
            }
            else
            {
                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine("Victory! The enemies have been vanquished.");
                    CombatPause();
                }
                Units.AddRange(DeadUnits);
                return false;
            }
        }

        public void UpdateTurn()
        {
            foreach (var unit in Units)
            {
                unit.TurnCalculation += unit.Speed;
            }

            foreach (var enemy in Enemies)
            {
                enemy.TurnCalculation += enemy.Speed;
            }
        }

        public void UseAbilityOnTeammate(BaseFighter actingUnit, BaseFighter helpedUnit, Ability abilityToUse)
        {
            if (abilityToUse.impactedTurns == 0)
            {
                var healthRegen = abilityToUse.ModifiedStat == StatEnum.MixedAttack
                    ? abilityToUse.Modifier + (actingUnit.PhysicalAttack + actingUnit.MagicAttack) / 2
                    : abilityToUse.Modifier + actingUnit.MagicAttack;

                helpedUnit.Health += healthRegen;
                if (helpedUnit.Health > helpedUnit.MaxHealth)
                {
                    helpedUnit.Health = helpedUnit.MaxHealth;
                }

                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine(abilityToUse.FlavorText);
                    Console.WriteLine($"{helpedUnit.CharacterName} healed {healthRegen} points of damage.");
                    CombatPause();
                }
            }
            else
            {
                helpedUnit.ModifiedStats.Add(new ModifiedStat()
                {
                    Modifier = abilityToUse.Modifier,
                    Stat = abilityToUse.ModifiedStat,
                    Turns = abilityToUse.impactedTurns,
                    IsNegative = false
                });

                ModifyStats(helpedUnit, abilityToUse.ModifiedStat, abilityToUse.Modifier, false);

                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine(abilityToUse.FlavorText);
                    Console.WriteLine($"{helpedUnit.CharacterName} was impacted by the ability.");
                    CombatPause();
                }
            }
        }

        public void UseAbilityOnEnemy(BaseFighter actingUnit, BaseFighter attackedEnemy, Ability abilityToUse)
        {
            if (abilityToUse.impactedTurns == 0)
            {
                var damage = 0;

                if (abilityToUse.ModifiedStat == StatEnum.MagicAttack)
                {
                    damage = abilityToUse.Modifier + actingUnit.MagicAttack - attackedEnemy.MagicDefense;
                }
                else if (abilityToUse.ModifiedStat == StatEnum.PhysicalAttack)
                {
                    damage = abilityToUse.Modifier + actingUnit.PhysicalAttack - attackedEnemy.PhysicalDefense;
                }
                else if (abilityToUse.ModifiedStat == StatEnum.MixedAttack)
                {
                    damage = abilityToUse.Modifier
                           + (actingUnit.PhysicalAttack + actingUnit.MagicAttack) / 2
                           - (attackedEnemy.PhysicalDefense + attackedEnemy.MagicDefense) / 2;
                }

                if (damage < 0)
                {
                    damage = 0;
                }

                if (CheckForCritical(actingUnit))
                {
                    damage += actingUnit.CritDamage;
                }

                attackedEnemy.Health -= damage;
                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine(abilityToUse.FlavorText);
                    Console.WriteLine($"{actingUnit.CharacterName} did {damage} points of damage to {attackedEnemy.CharacterName}.");
                    CombatPause();
                }
            }
            else
            {
                attackedEnemy.ModifiedStats.Add(new ModifiedStat()
                {
                    Modifier = abilityToUse.Modifier,
                    Stat = abilityToUse.ModifiedStat,
                    Turns = abilityToUse.impactedTurns,
                    IsNegative = true
                });

                ModifyStats(attackedEnemy, abilityToUse.ModifiedStat, abilityToUse.Modifier, true);

                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine(abilityToUse.FlavorText);
                    Console.WriteLine($"{attackedEnemy.CharacterName} was hit with this ability.");
                    CombatPause();
                }
            }
        }

        public void PhysicalAttack(BaseFighter actingUnit, BaseFighter attackedEnemy)
        {
            var damage = actingUnit.PhysicalAttack - attackedEnemy.PhysicalDefense;
            if (damage < 0)
            {
                damage = 0;
            }

            if (CheckForCritical(actingUnit))
            {
                damage += actingUnit.CritDamage;
            }

            if(CheckForDodge(attackedEnemy))
            {
                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine($"The attack from {actingUnit.CharacterName} missed");
                    CombatPause();
                }
            }
            else
            {
                attackedEnemy.Health -= damage;

                if (!IsSilent)
                {
                    Console.WriteLine();
                    Console.WriteLine($"{actingUnit.CharacterName} did {damage} points of damage to {attackedEnemy.CharacterName}.");
                    CombatPause();
                }
            }
        }

        public string DetermineAction(BaseFighter actingUnit)
        {
            bool hasAffordableAbility = actingUnit.Abilities.Any(x => x.ManaCost <= actingUnit.Mana);

            Console.WriteLine();
            Console.WriteLine($"[{actingUnit.CharacterName} the {actingUnit.CharacterType}]");
            if (hasAffordableAbility)
            {
                Console.WriteLine("Would you like to 'Attack', use an 'Ability', or show 'Stats'?");
            }
            else
            {
                Console.WriteLine("Would you like to 'Attack' or show 'Stats'?");
            }

            var line = (Console.ReadLine() ?? "").ToLower().Trim();

            if (line == "ability" && !hasAffordableAbility)
            {
                Console.WriteLine("You don't have enough mana for any abilities. Defaulting to Attack.");
                return "attack";
            }

            if (line == "attack" || line == "ability" || line == "stats")
                return line;

            Console.WriteLine("Unrecognized action. Defaulting to Attack.");
            return "attack";
        }

        private void ShowStatsMenu(List<BaseFighter> units, List<BaseFighter> enemies)
        {
            var allFighters = new List<BaseFighter>();
            allFighters.AddRange(units);
            allFighters.AddRange(enemies);

            while (true)
            {
                Console.WriteLine();
                Console.WriteLine("Select a character to view stats, or type 'back' to return.");
                Console.WriteLine("  Party:");
                for (int i = 0; i < units.Count; i++)
                {
                    Console.WriteLine($"    {i + 1}. {units[i].CharacterName} the {units[i].CharacterType}");
                }
                Console.WriteLine("  Enemies:");
                for (int i = 0; i < enemies.Count; i++)
                {
                    Console.WriteLine($"    {units.Count + i + 1}. {enemies[i].CharacterName} the {enemies[i].CharacterType}");
                }

                var input = (Console.ReadLine() ?? "").Trim().ToLower();

                if (input == "back")
                    return;

                if (int.TryParse(input, out int choice) && choice >= 1 && choice <= allFighters.Count)
                {
                    Console.WriteLine();
                    allFighters[choice - 1].ShowStats();
                }
                else
                {
                    Console.WriteLine("That's not a valid selection.");
                }
            }
        }

        private static string GetAbilityDescription(Ability a)
        {
            var target = a.UseOnEnemy ? "Enemy" : "Ally";
            if (a.TargetAll)
                target = a.UseOnEnemy ? "All Enemies" : "All Allies";

            string effect;
            if (!a.UseOnEnemy && a.impactedTurns == 0)
            {
                effect = "Heals";
            }
            else if (a.impactedTurns > 0)
            {
                string statName;
                switch (a.ModifiedStat)
                {
                    case StatEnum.Attack: statName = "Attack"; break;
                    case StatEnum.Defense: statName = "Defense"; break;
                    case StatEnum.PhysicalAttack: statName = "Physical Attack"; break;
                    case StatEnum.PhysicalDefense: statName = "Physical Defense"; break;
                    case StatEnum.MagicAttack: statName = "Magic Attack"; break;
                    case StatEnum.MagicDefense: statName = "Magic Defense"; break;
                    case StatEnum.Speed: statName = "Speed"; break;
                    case StatEnum.DodgeChance: statName = "Dodge"; break;
                    case StatEnum.Taunt: statName = "Taunt"; break;
                    default: statName = "Stats"; break;
                }
                var verb = a.UseOnEnemy ? "Reduces" : "Boosts";
                effect = $"{verb} {statName} for {a.impactedTurns} turn(s)";
            }
            else
            {
                switch (a.ModifiedStat)
                {
                    case StatEnum.PhysicalAttack: effect = "Physical damage"; break;
                    case StatEnum.MagicAttack: effect = "Magic damage"; break;
                    case StatEnum.MixedAttack: effect = "Mixed damage"; break;
                    default: effect = "Damage"; break;
                }
            }

            return $"[{target}] {effect}";
        }

        private static void CombatPause()
        {
            if (!IsSilent)
                Thread.Sleep(1200);
        }

        public Ability DetermineAbility(BaseFighter actingUnit)
        {
            var affordableAbilities = actingUnit.Abilities
                .Where(a => a.ManaCost <= actingUnit.Mana)
                .ToList();

            Console.WriteLine();
            Console.WriteLine($"Which ability do you want to use? Type number and press enter.");
            for (int i = 0; i < affordableAbilities.Count; i++)
            {
                var a = affordableAbilities[i];
                Console.WriteLine();
                Console.WriteLine($"  {i + 1}. {a.Name} (Mana: {a.ManaCost})");
                Console.WriteLine($"     {GetAbilityDescription(a)}");
            }

            while (true)
            {
                var abilityNumber = (Console.ReadLine() ?? "").Trim();
                if (int.TryParse(abilityNumber, out int abilityToUseNumber)
                    && abilityToUseNumber >= 1
                    && abilityToUseNumber <= affordableAbilities.Count)
                {
                    return affordableAbilities[abilityToUseNumber - 1];
                }
                Console.WriteLine("That's not a valid ability. Try again.");
            }
        }
        
        public BaseFighter ChooseAffectedUnit(List<BaseFighter> fighters)
        {
            Console.WriteLine();
            Console.WriteLine("Enter the number of the character you would like to affect and press enter.");

            for (int i = 0; i < fighters.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {fighters[i].CharacterName} the {fighters[i].CharacterType}");
            }

            while (true)
            {
                var unitNumber = (Console.ReadLine() ?? "").Trim();
                if (int.TryParse(unitNumber, out int affectedUnitNumber)
                    && affectedUnitNumber >= 1
                    && affectedUnitNumber <= fighters.Count)
                {
                    return fighters[affectedUnitNumber - 1];
                }
                Console.WriteLine("That's not a valid selection. Try again.");
            }
        }

        private void PlayerUseAbility(BaseFighter actingUnit, Ability abilityToUse)
        {
            actingUnit.Mana -= abilityToUse.ManaCost;

            if (abilityToUse.UseOnEnemy)
            {
                if (abilityToUse.TargetAll)
                {
                    Console.WriteLine($"{actingUnit.CharacterName} targets all enemies!");
                    foreach (var enemy in Enemies.ToList())
                        UseAbilityOnEnemy(actingUnit, enemy, abilityToUse);
                }
                else
                {
                    var attackedEnemy = GetTauntTarget(Enemies) ?? ChooseAffectedUnit(Enemies);
                    UseAbilityOnEnemy(actingUnit, attackedEnemy, abilityToUse);
                }
            }
            else
            {
                if (abilityToUse.TargetAll)
                {
                    Console.WriteLine($"{actingUnit.CharacterName} targets all allies!");
                    foreach (var ally in Units.ToList())
                        UseAbilityOnTeammate(actingUnit, ally, abilityToUse);
                }
                else
                {
                    var helpedUnit = ChooseAffectedUnit(Units);
                    UseAbilityOnTeammate(actingUnit, helpedUnit, abilityToUse);
                }
            }
        }

        public void ResetTurns()
        {
            foreach (var unit in Units)
            {
                if(unit.TurnCalculation >= 100)
                {
                    unit.TurnCalculation -= 100;
                }
            }

            foreach (var enemy in Enemies)
            {
                if (enemy.TurnCalculation >= 100)
                {
                    enemy.TurnCalculation -= 100;
                }
            }
        }

        public void ModifyStats(BaseFighter fighter, StatEnum modifiedStat, int modifier, bool negativeImpact)
        {
            switch (modifiedStat)
            {
                case StatEnum.Attack:
                    {
                        if(negativeImpact)
                        {
                            fighter.PhysicalAttack -= modifier;
                            fighter.MagicAttack -= modifier;
                        }
                        else
                        {
                            fighter.PhysicalAttack += modifier;
                            fighter.MagicAttack += modifier;
                        }
                        break;
                    }
                case StatEnum.Defense:
                    {
                        if (negativeImpact)
                        {
                            fighter.PhysicalDefense -= modifier;
                            fighter.MagicDefense -= modifier;
                        }
                        else
                        {
                            fighter.PhysicalDefense += modifier;
                            fighter.MagicDefense += modifier;
                        }
                        break;
                    }
                case StatEnum.PhysicalAttack:
                    {
                        if (negativeImpact)
                        {
                            fighter.PhysicalAttack -= modifier;
                        }
                        else
                        {
                            fighter.PhysicalAttack += modifier;
                        }
                        break;
                    }
                case StatEnum.MagicAttack:
                    {
                        if (negativeImpact)
                        {
                            fighter.MagicAttack -= modifier;
                        }
                        else
                        {
                            fighter.MagicAttack += modifier;
                        }
                        break;
                    }
                case StatEnum.PhysicalDefense:
                    {
                        if (negativeImpact)
                        {
                            fighter.PhysicalDefense -= modifier;
                        }
                        else
                        {
                            fighter.PhysicalDefense += modifier;
                        }
                        break;
                    }
                case StatEnum.MagicDefense:
                    {
                        if (negativeImpact)
                        {
                            fighter.MagicDefense -= modifier;
                        }
                        else
                        {
                            fighter.MagicDefense += modifier;
                        }
                        break;
                    }
                case StatEnum.Speed:
                    {
                        if (negativeImpact)
                        {
                            fighter.Speed -= modifier;
                        }
                        else
                        {
                            fighter.Speed += modifier;
                        }
                        break;
                    }
                case StatEnum.MixedAttack:
                    {
                        if (negativeImpact)
                        {
                            fighter.PhysicalAttack -= modifier;
                            fighter.MagicAttack -= modifier;
                        }
                        else
                        {
                            fighter.PhysicalAttack += modifier;
                            fighter.MagicAttack += modifier;
                        }
                        break;
                    }
                case StatEnum.DodgeChance:
                    {
                        if (negativeImpact)
                        {
                            fighter.DodgeChance -= modifier;
                        }
                        else
                        {
                            fighter.DodgeChance += modifier;
                        }
                        break;
                    }
            }

            fighter.PhysicalAttack = Math.Max(0, fighter.PhysicalAttack);
            fighter.PhysicalDefense = Math.Max(0, fighter.PhysicalDefense);
            fighter.MagicAttack = Math.Max(0, fighter.MagicAttack);
            fighter.MagicDefense = Math.Max(0, fighter.MagicDefense);
            fighter.Speed = Math.Max(1, fighter.Speed);
            fighter.DodgeChance = Math.Max(0, fighter.DodgeChance);
        }

        public void ResetModifiedStat(BaseFighter fighter)
        {
            var statsToRemove = new List<int>();

            for (int i = 0; i < fighter.ModifiedStats.Count; i++)
            {
                var modifiedStat = fighter.ModifiedStats[i];
                if (modifiedStat.Turns == 0)
                {
                    ModifyStats(fighter, modifiedStat.Stat, modifiedStat.Modifier, !modifiedStat.IsNegative);
                    statsToRemove.Add(i);
                }
                else
                {
                    modifiedStat.Turns -= 1;
                }
            }

            for (int i = 0; i < statsToRemove.Count; i++)
            {
                var stat = statsToRemove[i] - i;
                fighter.ModifiedStats.RemoveAt(stat);
            }
        }

        private void ExecuteAITurn(BaseFighter unit, List<BaseFighter> targets, List<BaseFighter> allies)
        {
            var abilities = unit.Abilities;
            _affordable.Clear();
            _healAbilities.Clear();
            _buffAbilities.Clear();
            _offensiveAbilities.Clear();
            Ability tauntAbility = null;
            bool hasAoeBuff = false;

            for (int i = 0; i < abilities.Count; i++)
            {
                var a = abilities[i];
                if (a.ManaCost > unit.Mana) continue;
                _affordable.Add(a);

                if (a.UseOnEnemy)
                {
                    _offensiveAbilities.Add(a);
                }
                else if (a.impactedTurns == 0)
                {
                    _healAbilities.Add(a);
                }
                else if (a.ModifiedStat == StatEnum.Taunt)
                {
                    tauntAbility = a;
                }
                else
                {
                    _buffAbilities.Add(a);
                    if (a.TargetAll) hasAoeBuff = true;
                }
            }

            float totalAttack = unit.MagicAttack + unit.PhysicalAttack;
            float magicRatio = totalAttack > 0 ? unit.MagicAttack / totalAttack : 0.5f;

            // Priority 1: Heal a wounded ally
            if (_healAbilities.Count > 0)
            {
                BaseFighter woundedAlly = null;
                for (int i = 0; i < allies.Count; i++)
                {
                    var a = allies[i];
                    if (a.Health > 0 && a.Health < a.MaxHealth * 0.5)
                    {
                        if (woundedAlly == null || a.Health < woundedAlly.Health)
                            woundedAlly = a;
                    }
                }

                if (woundedAlly != null)
                {
                    var heal = _healAbilities[unit.random.Next(0, _healAbilities.Count)];
                    unit.Mana -= heal.ManaCost;
                    if (heal.TargetAll)
                    {
                        for (int i = 0; i < allies.Count; i++)
                            if (allies[i].Health > 0)
                                UseAbilityOnTeammate(unit, allies[i], heal);
                    }
                    else
                    {
                        UseAbilityOnTeammate(unit, woundedAlly, heal);
                    }
                    return;
                }
            }

            // Priority 1.5: Taunt if defensive unit and not already taunting
            if (tauntAbility != null && !HasModifier(unit.ModifiedStats, StatEnum.Taunt, false))
            {
                float defenseTotal = unit.PhysicalDefense + unit.MagicDefense;
                float offenseTotal = unit.PhysicalAttack + unit.MagicAttack;
                float tankRatio = defenseTotal / (defenseTotal + offenseTotal);
                float tauntChance = tankRatio * (targets.Count / 3.0f);

                if (unit.random.NextDouble() < tauntChance)
                {
                    unit.Mana -= tauntAbility.ManaCost;
                    UseAbilityOnTeammate(unit, unit, tauntAbility);
                    return;
                }
            }

            // Priority 2: Small chance to buff allies (higher chance for AoE buffs)
            if (_buffAbilities.Count > 0)
            {
                int buffRoll = unit.random.Next(0, 5);
                bool tryBuff = buffRoll == 0 || (buffRoll <= 1 && hasAoeBuff);
                if (tryBuff)
                {
                    var buff = _buffAbilities[unit.random.Next(0, _buffAbilities.Count)];
                    if (buff.TargetAll)
                    {
                        bool anyUnbuffed = false;
                        for (int i = 0; i < allies.Count; i++)
                        {
                            if (allies[i].Health > 0 && !HasModifier(allies[i].ModifiedStats, buff.ModifiedStat, false))
                            {
                                anyUnbuffed = true;
                                break;
                            }
                        }
                        if (anyUnbuffed)
                        {
                            unit.Mana -= buff.ManaCost;
                            for (int i = 0; i < allies.Count; i++)
                                if (allies[i].Health > 0)
                                    UseAbilityOnTeammate(unit, allies[i], buff);
                            return;
                        }
                    }
                    else
                    {
                        BaseFighter buffTarget = null;
                        int bestTotal = int.MinValue;
                        for (int i = 0; i < allies.Count; i++)
                        {
                            if (allies[i].Health > 0)
                            {
                                int total = allies[i].PhysicalAttack + allies[i].MagicAttack;
                                if (total > bestTotal)
                                {
                                    bestTotal = total;
                                    buffTarget = allies[i];
                                }
                            }
                        }

                        if (buffTarget != null && !HasModifier(buffTarget.ModifiedStats, buff.ModifiedStat, false))
                        {
                            unit.Mana -= buff.ManaCost;
                            UseAbilityOnTeammate(unit, buffTarget, buff);
                            return;
                        }
                    }
                }
            }

            // Priority 3: Offensive ability vs physical attack based on magic ratio
            float abilityChance = magicRatio;
            if (magicRatio < 0.4f && _offensiveAbilities.Count > 0)
            {
                for (int i = 0; i < _offensiveAbilities.Count; i++)
                {
                    var stat = _offensiveAbilities[i].ModifiedStat;
                    if (stat == StatEnum.PhysicalAttack || stat == StatEnum.MixedAttack)
                    {
                        abilityChance = 0.4f;
                        break;
                    }
                }
            }
            bool useAbility = _offensiveAbilities.Count > 0 && unit.random.NextDouble() < abilityChance;

            if (useAbility)
            {
                var ability = ChooseOffensiveAbility(unit, _offensiveAbilities, magicRatio);
                unit.Mana -= ability.ManaCost;
                if (ability.TargetAll)
                {
                    for (int i = targets.Count - 1; i >= 0; i--)
                        UseAbilityOnEnemy(unit, targets[i], ability);
                }
                else
                {
                    var target = ChooseTarget(unit, targets, magicRatio);
                    UseAbilityOnEnemy(unit, target, ability);
                }
            }
            else
            {
                var target = ChooseTarget(unit, targets, magicRatio);
                PhysicalAttack(unit, target);
            }
        }

        private static bool HasModifier(List<ModifiedStat> mods, StatEnum stat, bool isNegative)
        {
            for (int i = 0; i < mods.Count; i++)
                if (mods[i].Stat == stat && mods[i].IsNegative == isNegative)
                    return true;
            return false;
        }

        private BaseFighter GetTauntTarget(List<BaseFighter> targets)
        {
            BaseFighter taunter = null;
            for (int i = 0; i < targets.Count; i++)
            {
                var t = targets[i];
                if (t.Health > 0 && HasModifier(t.ModifiedStats, StatEnum.Taunt, false))
                {
                    taunter = t;
                    break;
                }
            }
            if (taunter != null && !IsSilent)
            {
                Console.WriteLine($"{taunter.CharacterName} has taunted your attention!");
            }
            return taunter;
        }

        private BaseFighter ChooseTarget(BaseFighter unit, List<BaseFighter> targets, float magicRatio)
        {
            var taunter = FindTaunter(targets);
            if (taunter != null)
                return taunter;

            bool pickLowest = magicRatio > 0.6f
                || (magicRatio >= 0.4f && unit.random.NextDouble() < 0.6);

            return pickLowest ? FindMinHealth(targets) : FindMaxHealth(targets);
        }

        private static BaseFighter FindTaunter(List<BaseFighter> targets)
        {
            for (int i = 0; i < targets.Count; i++)
            {
                var t = targets[i];
                var mods = t.ModifiedStats;
                for (int j = 0; j < mods.Count; j++)
                    if (mods[j].Stat == StatEnum.Taunt && !mods[j].IsNegative)
                        return t;
            }
            return null;
        }

        private static BaseFighter FindMinHealth(List<BaseFighter> targets)
        {
            var best = targets[0];
            for (int i = 1; i < targets.Count; i++)
                if (targets[i].Health < best.Health)
                    best = targets[i];
            return best;
        }

        private static BaseFighter FindMaxHealth(List<BaseFighter> targets)
        {
            var best = targets[0];
            for (int i = 1; i < targets.Count; i++)
                if (targets[i].Health > best.Health)
                    best = targets[i];
            return best;
        }

        private Ability ChooseOffensiveAbility(BaseFighter unit, List<Ability> offensiveAbilities, float magicRatio)
        {
            var preferredStat = magicRatio > 0.5f ? StatEnum.MagicAttack : StatEnum.PhysicalAttack;
            int preferredCount = 0;
            for (int i = 0; i < offensiveAbilities.Count; i++)
            {
                var stat = offensiveAbilities[i].ModifiedStat;
                if (stat == preferredStat || stat == StatEnum.MixedAttack)
                    preferredCount++;
            }

            if (preferredCount > 0)
            {
                int pick = unit.random.Next(0, preferredCount);
                for (int i = 0; i < offensiveAbilities.Count; i++)
                {
                    var stat = offensiveAbilities[i].ModifiedStat;
                    if (stat == preferredStat || stat == StatEnum.MixedAttack)
                    {
                        if (pick == 0) return offensiveAbilities[i];
                        pick--;
                    }
                }
            }

            return offensiveAbilities[unit.random.Next(0, offensiveAbilities.Count)];
        }

        private bool CheckForCritical(BaseFighter fighter)
        {
            var critRoll = fighter.random.Next(1, 11);
            return critRoll > 10 - fighter.CritChance;
        }

        private bool CheckForDodge(BaseFighter fighter)
        {
            var dodgeRoll = fighter.random.Next(1, 11);
            return dodgeRoll <= fighter.DodgeChance;
        }

        public abstract void DetermineNextBattle();

        public bool IsFinalBattle { get; set; }

        public Battle NextBattle { get; set; }

        public abstract void PreBattleInteraction();
        public abstract void PostBattleInteraction();
    }
}
