using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Bear : BaseFighter
    {
        public Bear(int level = 2)
        {
            Level = level;
            Health = Stat(106, 126, 8, 14, 2);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 27, 3, 6, 2);
            PhysicalDefense = Stat(7, 12, 1, 3, 2);
            MagicAttack = Stat(5, 10, 1, 3, 2);
            MagicDefense = Stat(7, 12, 1, 3, 2);
            Speed = Stat(11, 27, 1, 3, 2);
            Abilities = new List<Ability>() { new Claw(), new Roar() };
            CharacterType = "Bear";
            CharacterName = "Winnie";
            Mana = Stat(5, 16, 1, 4, 2);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Bear(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Bear(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 14);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 6);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
