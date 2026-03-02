using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class GuardSergeant : BaseFighter
    {
        public GuardSergeant(int level = 12)
        {
            Level = level;
            Health = Stat(218, 248, 8, 12, 12);
            MaxHealth = Health;
            PhysicalAttack = Stat(45, 53, 3, 5, 12);
            PhysicalDefense = Stat(24, 30, 2, 3, 12);
            MagicAttack = Stat(8, 12, 0, 2, 12);
            MagicDefense = Stat(20, 24, 1, 2, 12);
            Speed = Stat(28, 34, 2, 3, 12);
            Abilities = new List<Ability>() { new SwordStrike(), new Rally(), new DecisiveBlow() };
            CharacterType = "Guard Sergeant";
            Mana = Stat(18, 24, 2, 4, 12);
            MaxMana = Mana;
            CritChance = 22;
            CritDamage = 4;
            DodgeChance = 12;
        }

        public GuardSergeant(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new GuardSergeant(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
