using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Automaton : BaseFighter
    {
        public Automaton()
        {
            Abilities = new List<Ability>() { new ServoStrike(), new ProgramDefense(), new Overclock() };
            CharacterType = "Automaton";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 1;
        }

        public Automaton(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Automaton(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 8;
            MaxHealth += 8;
            PhysicalDefense += 5;
            MagicAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(4, 7);
            MagicAttack += random.Next(6, 9);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
