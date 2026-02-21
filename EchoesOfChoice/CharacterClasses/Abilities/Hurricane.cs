using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Hurricane : Ability
    {
        public Hurricane()
        {
            Name = "Hurricane";
            FlavorText = "Giant gusts of wind sweep all enemies off their feet.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
