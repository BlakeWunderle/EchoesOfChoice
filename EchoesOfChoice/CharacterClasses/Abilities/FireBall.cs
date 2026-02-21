using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class FireBall : Ability
    {
        public FireBall()
        {
            Name = "Fire Ball";
            FlavorText = "Great ball of Fire!!";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
