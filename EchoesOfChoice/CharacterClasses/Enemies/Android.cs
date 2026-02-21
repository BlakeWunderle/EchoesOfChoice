using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Android : BaseFighter
    {
        public Android(int level = 6)
        {
            Level = level;
            Health = Stat(106, 116, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(30, 34, 0, 0, 6);
            PhysicalDefense = Stat(18, 22, 0, 0, 6);
            MagicAttack = Stat(26, 30, 0, 0, 6);
            MagicDefense = Stat(22, 27, 0, 0, 6);
            Speed = Stat(24, 28, 0, 0, 6);
            Abilities = new List<Ability>() { new CircuitBurst(), new Firewall(), new Overdrive() };
            CharacterType = "Android";
            Mana = Stat(28, 33, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Android(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Android(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
