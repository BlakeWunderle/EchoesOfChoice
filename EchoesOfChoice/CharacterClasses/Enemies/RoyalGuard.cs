using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class RoyalGuard : BaseFighter
    {
        public RoyalGuard(int level = 12)
        {
            Level = level;
            Health = Stat(208, 238, 8, 12, 12);
            MaxHealth = Health;
            PhysicalAttack = Stat(41, 49, 3, 5, 12);
            PhysicalDefense = Stat(34, 40, 3, 4, 12);
            MagicAttack = Stat(6, 10, 0, 2, 12);
            MagicDefense = Stat(24, 30, 2, 3, 12);
            Speed = Stat(26, 32, 2, 3, 12);
            Abilities = new List<Ability>() { new ShieldSlam(), new SwordStrike(), new DefensiveFormation() };
            CharacterType = "Royal Guard";
            Mana = Stat(16, 22, 2, 4, 12);
            MaxMana = Mana;
            CritChance = 18;
            CritDamage = 3;
            DodgeChance = 15;
        }

        public RoyalGuard(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new RoyalGuard(this);
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
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(2, 3);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
